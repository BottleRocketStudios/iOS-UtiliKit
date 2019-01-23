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
    
    private var containerTransitionCoordinator: ContainerTransitionCoordinator?
    override open var transitionCoordinator: UIViewControllerTransitionCoordinator? { return containerTransitionCoordinator }
    private var containerTransitionContext: UIViewControllerContextTransitioning?
    
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
    
    open func transitionToController(for child: ManagedChild, completion: ((Bool) -> Void)? = nil) {
        if !managedChildren.contains { $0.viewController === child.viewController } {
            managedChildren.insert(child, at: managedChildren.startIndex)
        }
        
        if !isViewLoaded, managedChildren.first?.identifier != child.identifier {
            managedChildren.removeAll { $0.identifier == child.identifier }
            managedChildren.insert(child, at: managedChildren.startIndex)
        }
        
        transition(to: child.viewController, completion: completion)
    }
    
    open func child(at index: Int) -> ManagedChild? {
        guard index >= managedChildren.startIndex && index < managedChildren.endIndex else { return nil }
        return managedChildren[index]
    }
}

//MARK: Transitioning
private extension ContainerViewController {
    
    func transition(to destination: UIViewController, completion: ((Bool) -> Void)? = nil) {
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
        
        //Begin the internal transitioning process, using a UIViewControllerAnimatedTransitioning object
        prepareForTransitioning(from: source, to: destination, animated: true)
        let animator = delegate?.containerViewController(self, animationControllerForTransitionFrom: source, to: destination) ?? ContainerTransitionAnimator()
        let interactor = delegate?.containerViewController(self, interactionControllerForTransitionFrom: source, to: destination)
        
        let context = ContainerTransitionContext(containerView: view, fromViewController: source, toViewController: destination)
        context.isInteractive = (interactor != nil)
        context.completion = { [weak self] finished in
            self?.finishTransitioning(from: source, to: destination, success: finished, animated: true)
        }
        
        if context.isInteractive {
            //The transition is interactive, it should begin using the interaction controller before transitioning (heh) to animation
            interactor?.startInteractiveTransition(context)
        } else {
            //Instruct the animator to begin transitioning
            animator.animateTransition(using: context)
        }

        containerTransitionContext = context
        
        //Inform the delegate transitioning has begun
        delegate?.containerViewController(self, didBeginTransitioningFrom: source, to: destination)
    }
}

//MARK: Helper
private extension ContainerViewController {
    
    func prepareForTransitioning(from source: UIViewController?, to destination: UIViewController, animated: Bool) {
        isTransitioning = true
        
        #if swift(>=4.2)
        source?.willMove(toParent: nil)
        source?.beginAppearanceTransition(false, animated: animated)
        
        destination.willMove(toParent: self)
        destination.beginAppearanceTransition(true, animated: animated)
        addChild(destination)
        #else
        source?.willMove(toParentViewController: nil)
        source?.beginAppearanceTransition(false, animated: animated)
        
        destination.willMove(toParentViewController: self)
        destination?.beginAppearanceTransition(true, animated: animated)
        addChildViewController(destination)
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
            destination.didMove(toParent: self)
            destination.endAppearanceTransition()
            
            source?.removeFromParent()
            source?.didMove(toParent: nil)
            source?.endAppearanceTransition()
            #else
            destination.didMove(toParentViewController: self)
            destination.endAppearanceTransition()
            
            source?.removeFromParentViewController()
            source?.didMove(toParentViewController: nil)
            source?.endAppearanceTransition()
            #endif
            
            visibleController = destination
            
        } else {
            #if swift(>=4.2)
            destination.willMove(toParent: nil)
            destination.beginAppearanceTransition(false, animated: animated)
            destination.removeFromParent()
            destination.endAppearanceTransition()
            destination.didMove(toParent: nil)
            
            source?.willMove(toParent: self)
            source?.beginAppearanceTransition(true, animated: animated)
            source?.endAppearanceTransition()
            source?.didMove(toParent: self)
            #else
            destination.willMove(toParentViewController: nil)
            destination.beginAppearanceTransition(false, animated: animated)
            destination.removeFromParentViewController()
            destination.endAppearanceTransition()
            destination.didMove(toParentViewController: nil)
            
            source?.willMove(toParentViewController: self)
            source?.beginAppearanceTransition(true, animated: animated)
            source?.endAppearanceTransition()
            source?.didMove(toParentViewController: self)
            #endif
            
            visibleController = source
        }
        
        isTransitioning = false
    }
}
