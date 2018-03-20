//
//  ContainerTransitionContext.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ContainerTransitionContext: NSObject {
    
    typealias ContainerTransitionCompletionBlock = (Bool) -> Void
    
    //MARK: Properties
    let container: UIViewController
    let source: UIViewController
    let destination: UIViewController
    var completion: ContainerTransitionCompletionBlock?
    
    let viewControllers: [UITransitionContextViewControllerKey: UIViewController]
    let views: [UITransitionContextViewKey: UIView]
    
    //MARK: Initializers
    init(containerViewController: UIViewController, sourceViewController: UIViewController, destinationViewController: UIViewController, completionHandler: ContainerTransitionCompletionBlock? = nil ) {
        container = containerViewController
        source = sourceViewController
        destination = destinationViewController
        completion = completionHandler
        
        viewControllers = [.from : sourceViewController,
                           .to : destinationViewController]
        
        views = [.from: sourceViewController.view,
                 .to: destinationViewController.view]
        super.init()
    }
}

//MARK: UIViewControllerContextTransitioning
extension ContainerTransitionContext: UIViewControllerContextTransitioning {
    
    //MARK: Context Metadata
    var containerView: UIView {
        return container.view
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return viewControllers[key]
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return views[key]
    }
    
    /// The frame's are set to CGRectZero when they are not known or otherwise undefined.  For example the finalFrame of the fromViewController will be CGRectZero if and only if the fromView will be removed from the window at the end of the transition. On the other hand, if the finalFrame is not CGRectZero then it must be respected at the end of the transition.
    func initialFrame(for vc: UIViewController) -> CGRect {
        guard vc == source else { return .zero }
        return containerView.bounds
    }
    
    /// The frame's are set to CGRectZero when they are not known or otherwise undefined.  For example the finalFrame of the fromViewController will be CGRectZero if and only if the fromView will be removed from the window at the end of the transition. On the other hand, if the finalFrame is not CGRectZero then it must be respected at the end of the transition.
    func finalFrame(for vc: UIViewController) -> CGRect {
        guard vc == destination else { return .zero }
        return containerView.bounds
    }
    
    var presentationStyle: UIModalPresentationStyle {
        return destination.modalPresentationStyle
    }
    
    var isAnimated: Bool {
        return true
    }
    
    var targetTransform: CGAffineTransform {
        return .identity
    }
    
    //MARK: Interactivity
    var isInteractive: Bool {
        return false
    }
    
    var transitionWasCancelled: Bool {
        return false //We only support non-interactive transitions - it won't be cancelled
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) { /* No op */ }
    func finishInteractiveTransition() { /* No op */ }
    func cancelInteractiveTransition() { /* No op */ }
    func pauseInteractiveTransition() { /* No op */ }
    
    //MARK: Completion
    
    // This must be called whenever a transition completes (or is cancelled.). Typically this is called by the object conforming to the UIViewControllerAnimatedTransitioning protocol that was vended by the transitioning delegate. For purely interactive transitions it should be called by the interaction controller. This method effectively updates internal view controller state at the end of the transition.
    func completeTransition(_ didComplete: Bool) {
        completion?(didComplete)
    }
}
