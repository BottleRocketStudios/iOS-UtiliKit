//
//  ContainerViewController.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {
    
    // MARK: Subtypes
    public enum PostTransitionBehavior {
        case removeAllNonVisibleChildrenExcept([AnyHashable])
        case none
        
        public static var removeAllNonVisibleChildren: PostTransitionBehavior { return .removeAllNonVisibleChildrenExcept([]) }
    }
    
    //MARK: Properties
    open var managedChildren: [ManagedChild] = []
    open var visibleIndex: Int? { return visibleController.flatMap(index(ofChild:)) }
    open var visibleChild: ManagedChild? { return managedChildren.first { $0.viewController === visibleController } }
    
    open private(set) var isTransitioning: Bool = false
    open var shouldAutomaticallyTransitionOnLoad: Bool = true
    
    open var visibleController: UIViewController? {
        didSet { visibleController.map { transition(to: $0) } }
    }
    
    open weak var delegate: ContainerViewControllerDelegate?
    
    // MARK: Transitioning
    private var containerTransitionContext: UIViewControllerContextTransitioning?
    open var containerTransitionCoordinator: ContainerViewControllerTransitionCoordinator?
    open var postTransitionBehavior: PostTransitionBehavior = .none
    
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
    
    // MARK: Public Interface
    open func child(at index: Int) -> ManagedChild? {
        guard index >= managedChildren.startIndex && index < managedChildren.endIndex else { return nil }
        return managedChildren[index]
    }
    
    open func addManagedChildIfNeeded(_ child: ManagedChild) {
        if !managedChildren.contains(where: { $0.viewController === child.viewController }) {
            managedChildren.insert(child, at: managedChildren.startIndex)
        }
        
        if !isViewLoaded, managedChildren.first?.identifier != child.identifier {
            managedChildren.removeAll { $0.identifier == child.identifier }
            managedChildren.insert(child, at: managedChildren.startIndex)
        }
    }
    
    open func transitionToControllerForChild(withIdentifier identifier: AnyHashable, completion: ((Bool) -> Void)? = nil) {
        managedChildren.first { identifier == $0.identifier }.map { transitionToController(for: $0, completion: completion) }
    }
    
    open func transitionToController(for child: ManagedChild, completion: ((Bool) -> Void)? = nil) {
        addManagedChildIfNeeded(child)
        transition(to: child.viewController, completion: completion)
    }
}

//MARK: Transitioning
private extension ContainerViewController {
    
    func transition(to destination: UIViewController, completion: ((Bool) -> Void)? = nil) {
        //Ensure that the view is loaded, we're not already transitioning and the transition will result in a move
        guard isViewLoaded && !isTransitioning, visibleController != destination else { completion?(true); return }
        guard let source = visibleController else {
            
            //If we do not already have a visible controller (first launch), skip the animator and contain the child
            prepareForTransitioning(from: nil, to: destination, animated: false)
            view.addSubview(destination.view)
            configure(destinationView: destination.view, inContainer: view)
            finishTransitioning(from: nil, to: destination, success: true, animated: false)
            completion?(true); return
        }
        
        guard delegate?.containerViewController(self, shouldTransitionFrom: source, to: destination) ?? true else { completion?(false); return }
        
        prepareForTransitioning(from: source, to: destination, animated: true)
        defer { delegate?.containerViewController(self, didBeginTransitioningFrom: source, to: destination) }
        
        let context = configuredTransitionContext(from: source, to: destination, completion: completion)
        let animator = delegate?.containerViewController(self, animationControllerForTransitionFrom: source, to: destination) ?? DefaultContainerTransitionAnimator()
        let interactor = delegate?.containerViewController(self, interactionControllerForTransitionFrom: source, to: destination)
        
        containerTransitionCoordinator = ContainerTransitionCoordinator(context: context, animator: animator, interactor: interactor)
        if let interactor = interactor, interactor.wantsInteractiveStart {
            interactor.startInteractiveTransition(context, using: animator)
        } else {
            animator.animateTransition(using: context)
        }
    }
}

//MARK: Helper
private extension ContainerViewController {
    
    func configuredTransitionContext(from source: UIViewController, to destination: UIViewController, completion: ((Bool) -> Void)? = nil) -> ContainerTransitionContext {
        let context = ContainerTransitionContext(containerView: view, fromViewController: source, toViewController: destination)
        context.completion = { [unowned context, weak self] finished in
            guard let self = self else { return }
            self.finishTransitioning(from: source, to: destination, success: !context.transitionWasCancelled, animated: true)
            self.delegate?.containerViewController(self, didFinishTransitioningFrom: source, to: destination)
            completion?(finished)
        }
        
        return context
    }
    
    func prepareForTransitioning(from source: UIViewController?, to destination: UIViewController, animated: Bool) {
        isTransitioning = true
        
        source?.beginAppearanceTransition(false, animated: animated)
        destination.beginAppearanceTransition(true, animated: animated)
        
        addChild(destination)
        destination.didMove(toParent: self)
    }
    
    func configure(destinationView: UIView, inContainer container: UIView) {
        //It is the animator's responsibility (as with all UIViewControllerAnimatedTransitioning objects) to add the destinationView as a subview of the container view. The container will simply ensure the proper layout is used once the transition is completed.
        
        destinationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destinationView.frame = container.bounds
    }
    
    func finishTransitioning(from source: UIViewController?, to destination: UIViewController, success: Bool, animated: Bool) {
        destination.endAppearanceTransition()
        source?.endAppearanceTransition()
        
        if success {
            source?.willMove(toParent: nil)
            source?.view.removeFromSuperview()
            source?.removeFromParent()
           
            visibleController = destination
            
        } else {
            destination.willMove(toParent: nil)
            destination.view.removeFromSuperview()
            destination.removeFromParent()
            
            visibleController = source
        }
        
        switch postTransitionBehavior {
        case .removeAllNonVisibleChildrenExcept(let identifiers):
            removeAllNonVisibleChildren(except: identifiers)
        case .none:
            break
        }
        
        containerTransitionContext = nil
        isTransitioning = false
    }
    
    func removeAllNonVisibleChildren(except identifiers: [AnyHashable]) {
        managedChildren.forEach {
            if $0.viewController != visibleChild?.viewController && !identifiers.contains($0.identifier) {
                removeChild($0)
            }
        }
    }
}
