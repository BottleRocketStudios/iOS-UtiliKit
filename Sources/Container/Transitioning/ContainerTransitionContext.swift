//
//  ContainerTransitionContext.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/// This class is internal to the framework. Its concrete class type is never leaked and is instead exposed simply as an object conforming to `UIViewControllerContextTransitioning`. Its purpose is to function as a drop in replacement for the transition context objects vended by UIKit for presentations. Because the container utilizes its own child-based transition environment, UIKit will not create a transition context for its transitions. This context supports both interactive and animated transitions.
class ContainerTransitionContext: NSObject {
    
    typealias Completion = (Bool) -> Void
    
    // MARK: Properties
    var containerView: UIView
    var percentComplete: CGFloat = 0
    var presentationStyle: UIModalPresentationStyle
    var transitionWasCancelled: Bool = false
    var targetTransform: CGAffineTransform = .identity
    var isAnimated: Bool = true
    var isInteractive: Bool = false
    
    private var viewControllers: [UITransitionContextViewControllerKey: UIViewController]
    private var views: [UITransitionContextViewKey: UIView]
    
    var completion: Completion?
    
    // MARK: Initializers
    init(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        self.containerView = containerView
        self.presentationStyle = toViewController.modalPresentationStyle
        self.viewControllers = [.from: fromViewController, .to: toViewController]
        self.views = [.from: fromViewController.view, .to: toViewController.view]
        super.init()
    }
}

// MARK: UIViewControllerContextTransitioning
extension ContainerTransitionContext: UIViewControllerContextTransitioning {
    
    /// The frame's are set to .null when they are not known or otherwise undefined.  For example the finalFrame of the fromViewController will be .null if and only if the fromView will be removed from the window at the end of the transition. On the other hand, if the finalFrame is not .null then it must be respected at the end of the transition.
    func initialFrame(for vc: UIViewController) -> CGRect {
        guard vc == viewController(forKey: .from) else { return .null }
        return containerView.bounds
    }

    /// The frame's are set to .null when they are not known or otherwise undefined.  For example the finalFrame of the fromViewController will be .null if and only if the fromView will be removed from the window at the end of the transition. On the other hand, if the finalFrame is not .null then it must be respected at the end of the transition.
    func finalFrame(for vc: UIViewController) -> CGRect {
        guard vc == viewController(forKey: .to) else { return .null }
        return containerView.bounds
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return viewControllers[key]
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return views[key]
    }
    
    func completeTransition(_ didComplete: Bool) {
        completion?(didComplete)
    }
    
    func updateInteractiveTransition(_ complete: CGFloat) {
        percentComplete = complete
        isInteractive = true
    }

    func finishInteractiveTransition() {
        transitionWasCancelled = false
        isInteractive = false
    }

    func cancelInteractiveTransition() {
        transitionWasCancelled = true
        isInteractive = false
    }

    func pauseInteractiveTransition() {
        isInteractive = true
    }
}
