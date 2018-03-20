//
//  ContainerViewController.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

//MARK: Child Subtype
public struct Child {
    public let title: String
    public let viewController: UIViewController
    
    public init(title: String, viewController: UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}

open class ContainerViewController: UIViewController {
    
    //MARK: Properties
    public var children: [Child] = []
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
    
    public weak var delegate: ContainerViewControllerDelegate?
    
    //MARK: Initializers
    public convenience init(children: [Child]) {
        self.init(nibName: nil, bundle: nil)
        self.children = children
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
        
        guard shouldAutomaticallyTransitionOnLoad, let initial = children.first else { return }
        transition(to: initial.viewController)
    }
}

//MARK: Public Interface
extension ContainerViewController {
    
    open func transitionToController(for child: Child) {
        transition(to: child.viewController)
    }
    
    open func index(ofChild controller: UIViewController) -> Int? {
        return children.index(where: { $0.viewController == controller })
    }
}

//MARK: Transitioning
private extension ContainerViewController {
    
    func transition(to destination: UIViewController) {
        
        //Ensure that the view is loaded, we're not already transitioning and the transition will result in a move
        guard isViewLoaded && !isTransitioning, visibleController != destination else { return }
        guard let source = visibleController else {
            
            //If we do not already have a visible controller (first launch), skip the animator and contain the child
            prepareForTransitioning(from: nil, to: destination, animated: false)
            add(destinationView: destination.view, toContainer: view, animated: false)
            finishTransitioning(from: nil, to: destination, animated: false)
            return
        }
        
        guard delegate?.containerViewController(self, shouldTransitionFrom: source, to: destination) ?? true else { return }
        
        //Inform the delegate transitioning is set to begin
        delegate?.containerViewController(self, didBeginTransitioningFrom: source, to: destination)
        
        //Begin the internal transitioning process, using a UIViewControllerAnimatedTransitioning object
        prepareForTransitioning(from: source, to: destination, animated: true)
        let animator = delegate?.containerViewController(self, animationControllerForTransitionFrom: source, to: destination) ?? ContainerViewControllerTransitionAnimator()
        let transitionContext = ContainerTransitionContext(containerViewController: self, sourceViewController: source, destinationViewController: destination) { [weak self] finished in
            guard let blockSelf = self else { return }
            blockSelf.configure(destinationView: destination.view, inContainer: blockSelf.view)
            blockSelf.finishTransitioning(from: source, to: destination, animated: true)
            blockSelf.delegate?.containerViewController(blockSelf, didFinishTransitioningFrom: source, to: destination)
        }
        
        //Instruct the animator to begin transitioning
        animator.animateTransition(using: transitionContext)
    }
}

//MARK: Helper
private extension ContainerViewController {
    
    func prepareForTransitioning(from source: UIViewController?, to destination: UIViewController, animated: Bool) {
        isTransitioning = true
        
        source?.willMove(toParentViewController: nil)
        destination.willMove(toParentViewController: self)
        addChildViewController(destination)
    }
    
    func add(destinationView: UIView, toContainer container: UIView, animated: Bool) {
        container.addSubview(destinationView)
        configure(destinationView: destinationView, inContainer: container)
    }
    
    func configure(destinationView: UIView, inContainer container: UIView) {
        destinationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destinationView.frame = container.bounds
    }
    
    func removeSourceControllerFromContainer(_ source: UIViewController, animated: Bool) {
        source.view.removeFromSuperview()
        source.removeFromParentViewController()
        
        source.didMove(toParentViewController: nil)
    }
    
    func finishTransitioning(from source: UIViewController?, to destination: UIViewController, animated: Bool) {
        source.map { removeSourceControllerFromContainer($0, animated: animated) }
        destination.didMove(toParentViewController: self)
        
        visibleController = destination
        isTransitioning = false
    }
}
