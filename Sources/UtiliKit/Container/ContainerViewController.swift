//
//  ContainerViewController.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {
    
    //MARK: Properties
    public var managedChildren: [ManagedChild] = []
    public private(set) var isTransitioning: Bool = false
    public var shouldAutomaticallyTransitionOnLoad: Bool = true
    public var visibleController: UIViewController? {
        didSet {
            guard let visible = visibleController else { return }
            transition(to: visible)
        }
    }
    public var visibleIndex: Int? {
        return visibleController.flatMap { index(ofChild: $0 ) }
    }
    public var visibleChild: ManagedChild? {
        return managedChildren.first{ $0.viewController === visibleController }
    }
    
    private var containerTransitionContext: UIViewControllerContextTransitioning?
    private var containerTransitionCoordinator: UIViewControllerTransitionCoordinator?
    open override var transitionCoordinator: UIViewControllerTransitionCoordinator? { return containerTransitionCoordinator }
    
    public weak var delegate: ContainerViewControllerDelegate?
    
    //MARK: Initializers
    public convenience init(managedChildren: [ManagedChild], delegate: ContainerViewControllerDelegate? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.managedChildren = managedChildren
        self.delegate = delegate
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        guard shouldAutomaticallyTransitionOnLoad, let initial = managedChildren.first else { return }
        transition(to: initial.viewController)
    }
}

//MARK: Public Interface
extension ContainerViewController {
    
    open func transitionToController(for child: ManagedChild, allowInteraction: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if !managedChildren.contains { $0.viewController === child.viewController } {
            managedChildren.insert(child, at: managedChildren.startIndex)
        }
        
        if !isViewLoaded, managedChildren.first?.identifier != child.identifier {
            managedChildren.removeAll { $0.identifier == child.identifier }
            managedChildren.insert(child, at: managedChildren.startIndex)
        }
        
        transition(to: child.viewController, allowInteraction: allowInteraction, completion: completion)
    }
    
    open func child(at index: Int) -> ManagedChild? {
        guard index >= managedChildren.startIndex && index < managedChildren.endIndex else { return nil }
        return managedChildren[index]
    }
}

//MARK: Transitioning
private extension ContainerViewController {
    
    func transition(to destination: UIViewController, allowInteraction: Bool = true, completion: ((Bool) -> Void)? = nil) {
        //Ensure that the view is loaded, we're not already transitioning and the transition will result in a move
        guard isViewLoaded && !isTransitioning, visibleController != destination else { return }
        guard let source = visibleController else {
            
            //If we do not already have a visible controller (first launch), skip the animator and contain the child
            prepareForTransitioning(from: nil, to: destination, animated: false)
            view.addSubview(destination.view)
            configure(destinationView: destination.view, inContainer: view)
            finishTransitioning(from: nil, to: destination, success: true, animated: false)
            completion?(true); return
        }
        
        guard delegate?.containerViewController(self, shouldTransitionFrom: source, to: destination) ?? true else { return }
        
        prepareForTransitioning(from: source, to: destination, animated: true)
        let context = configuredTransitionContext(from: source, to: destination)
        
        if let animator = delegate?.containerViewController(self, animationControllerForTransitionFrom: source, to: destination) {
            if allowInteraction, let interactor = delegate?.containerViewController(self, interactionControllerForTransitionFrom: source, to: destination) {
                containerTransitionCoordinator = ContainerTransitionCoordinator(context: context, animator: animator, interactionController: interactor)
                interactor.startInteractiveTransition(context, animator: animator)
            } else {
                containerTransitionCoordinator = ContainerTransitionCoordinator(context: context, animator: animator)
                animator.animateTransition(using: context)
            }
        } else {
            let animator: UIViewControllerAnimatedTransitioning = ContainerTransitionAnimator()
            containerTransitionCoordinator = ContainerTransitionCoordinator(context: context, animator: animator)
            animator.animateTransition(using: context)
        }
        if allowInteraction, let interactor = delegate?.containerViewController(self, interactionControllerForTransitionFrom: source, to: destination) {
            
            //The delegate has vended an interaction controller, we will use it to drive the transition to completion
            context.isInteractive = allowInteraction
            interactor.startInteractiveTransition(context)
        } else {
            
            //The delegate did not vend an interaction controller, we'll drive the animation using an animation controller instead.
            let animator = delegate?.containerViewController(self, animationControllerForTransitionFrom: source, to: destination) ?? ContainerTransitionAnimator()
            animator.animateTransition(using: context)
        }

        //Inform the delegate transitioning has begun
        delegate?.containerViewController(self, didBeginTransitioningFrom: source, to: destination)
    }
}

//MARK: Helper
private extension ContainerViewController {
    
    func configuredTransitionContext(from source: UIViewController, to destination: UIViewController) -> ContainerTransitionContext {
        let context = ContainerTransitionContext(containerView: view, fromViewController: source, toViewController: destination)
        context.completion = { [weak self] finished in
            guard let self = self else { return }
            self.finishTransitioning(from: source, to: destination, success: finished, animated: true)
            self.delegate?.containerViewController(self, didFinishTransitioningFrom: source, to: destination)
        }
        
        containerTransitionContext = context
        return context
    }
    
    func prepareForTransitioning(from source: UIViewController?, to destination: UIViewController, animated: Bool) {
        isTransitioning = true
        
        #if swift(>=4.2)
        source?.beginAppearanceTransition(false, animated: animated)
        
        destination.beginAppearanceTransition(true, animated: animated)
        addChild(destination)
        destination.didMove(toParent: self)
        #else
        source?.beginAppearanceTransition(false, animated: animated)
        
        destination.beginAppearanceTransition(true, animated: animated)
        addChildViewController(destination)
        destination.didMove(toParentViewController: self)
        #endif
    }
    
    func configure(destinationView: UIView, inContainer container: UIView) {
        //It is the animator's responsibility to add the destinationView as a subview of the container view. The container will simply ensure the proper layout is used once the transition is completed.
        
        destinationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destinationView.frame = container.bounds
    }
    
    func finishTransitioning(from source: UIViewController?, to destination: UIViewController, success: Bool, animated: Bool) {
        //It is the animator's responsibility to remove the source view from it's superview in the case of a successful transition, or the destination in the case of a cancellation.
        
        if success {
            #if swift(>=4.2)
            destination.endAppearanceTransition()

            source?.endAppearanceTransition()
            source?.willMove(toParent: nil)
            source?.removeFromParent()
            #else
            destination.endAppearanceTransition()
            
            source?.endAppearanceTransition()
            source?.willMove(toParentViewController: nil)
            source?.removeFromParentViewController()
            #endif
            
            visibleController = destination
            
        } else {
            #if swift(>=4.2)
            destination.endAppearanceTransition()
            destination.willMove(toParent: nil)
            destination.removeFromParent()
            
            source?.endAppearanceTransition()
            #else
            destination.endAppearanceTransition()
            destination.willMove(toParentViewController: nil)
            destination.removeFromParentViewController()
            
            source?.endAppearanceTransition()
            #endif
            
            visibleController = source
        }
        
        containerTransitionContext = nil
        isTransitioning = false
    }
}
