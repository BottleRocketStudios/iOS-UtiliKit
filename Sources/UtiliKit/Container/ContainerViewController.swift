//
//  ContainerViewController.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {
    
    //MARK: Properties
    public let childManager = ChildManager(children: [])
    open var visibleController: UIViewController? {
        didSet { visibleController.map { transition(to: $0) } }
    }
    
    open var shouldAutomaticallyTransitionOnLoad: Bool = true
    open var insertionBehavior: ChildManager.InsertionBehavior {
        get { return childManager.insertionBehavior }
        set { childManager.insertionBehavior = newValue }
    }
    
    open private(set) var isTransitioning: Bool = false
    open var visibleChild: Child? { return visibleController.flatMap(childManager.existingChild) }
    
    open weak var delegate: ContainerViewControllerDelegate?
    
    // MARK: Transitioning
    private var containerTransitionContext: UIViewControllerContextTransitioning?
    open var containerTransitionCoordinator: ContainerViewControllerTransitionCoordinator?
    
    //MARK: Initializers
    public convenience init(children: [Child], delegate: ContainerViewControllerDelegate? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.childManager.children = children
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
        
        if shouldAutomaticallyTransitionOnLoad, let initial = childManager.children.first {
            transition(to: initial.viewController)
        }
    }
}

//MARK: Public Interface
extension ContainerViewController {
    
    open func transitionToExistingChild(with identifier: Child.Identifier, completion: ((Bool) -> Void)? = nil) {
        childManager.existingChild(with: identifier).map { transition(to: $0, completion: completion) }
    }
   
    open func transition(to child: Child, completion: ((Bool) -> Void)? = nil) {
        if !childManager.contains(child) {
            childManager.insert(child)
        }
        
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
        
        containerTransitionContext = nil
        isTransitioning = false
    }
}
