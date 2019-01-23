//
//  ContainerTransitionCoordinator.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ContainerTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {
    
    // MARK: Typealias
    typealias ContextHandler = (UIViewControllerTransitionCoordinatorContext) -> Swift.Void
    
    // MARK: Properties
    private var animations: [ContextHandler] = []
    private var nonContaineeAnimatedViews: [UIView] = []
    private var completionCallbacks: [ContextHandler] = []
    private var endNotificationCallbacks: [ContextHandler] = []
    private var changeNotificationCallbacks: [ContextHandler] = []
    
    internal(set) public var isAnimated: Bool = true
    internal(set) public var presentationStyle: UIModalPresentationStyle = .none
    internal(set) public var initiallyInteractive: Bool = false
    internal(set) public var isInterruptible: Bool = false
    internal(set) public var isInteractive: Bool = false
    internal(set) public var isCancelled: Bool = false
    internal(set) public var transitionDuration: TimeInterval = 0.5
    
    // These three methods are potentially meaningful for interactive transitions that are
    // completing. It reports the percent complete of the transition when it moves
    // to the non-interactive completion phase of the transition.
    public var percentComplete: CGFloat = 0
    public var completionVelocity: CGFloat = 1.0
    public var completionCurve: UIView.AnimationCurve = .linear
    
    private var viewControllers: [UITransitionContextViewControllerKey:UIViewController]
    private var views: [UITransitionContextViewKey:UIView]
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return viewControllers[key]
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return views[key]
    }
    
    public var containerView: UIView
    
    public var targetTransform: CGAffineTransform = CGAffineTransform.identity
    
    init(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        self.containerView = containerView
        self.viewControllers = [
            UITransitionContextViewControllerKey.from: fromViewController,
            UITransitionContextViewControllerKey.to: toViewController
        ]
        self.views = [
            UITransitionContextViewKey.from: fromViewController.view,
            UITransitionContextViewKey.to: toViewController.view
        ]
        
        super.init()
    }
}

extension ContainerTransitionCoordinator {
    
    var otherAnimatedViews: [UIView] {
        return nonContaineeAnimatedViews
    }
    
    func performAlongsideAnimations() {
        animations.forEach { (callback) in
            callback(self)
        }
    }
    
    func completeTransition() {
        completionCallbacks.forEach { (callback) in
            callback(self)
        }
    }
    
    func notifyThatInteractionStopped() {
        self.isInteractive = false
        notifyInteractionChanged()
        notifyInteractionEnded()
    }
    
    func notifyInteractionChanged() {
        changeNotificationCallbacks.forEach { (notificationCallbacks) in
            notificationCallbacks(self)
        }
    }
    
    func notifyInteractionEnded() {
        endNotificationCallbacks.forEach { (notificationCallbacks) in
            notificationCallbacks(self)
        }
    }
    
}

extension ContainerTransitionCoordinator {
    
    public func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)? = nil) -> Bool {
        
        let addedAnimation = add(alongsideAnimation: animation)
        let addedCompletionBlock = add(completionBlock: completion)
        return addedAnimation || addedCompletionBlock
    }
    
    public func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)? = nil) -> Bool {
        
        let addedNonContaineeView = add(viewForAnimation: view)
        let addedAnimation = add(alongsideAnimation: animation)
        let addedCompletionBlock = add(completionBlock: completion)
        return addedNonContaineeView || addedAnimation || addedCompletionBlock
    }
    
    public func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Swift.Void) {
        endNotificationCallbacks.append(handler)
    }
    
    public func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Swift.Void) {
        changeNotificationCallbacks.append(handler)
    }
    
}

private extension ContainerTransitionCoordinator {
    
    func add(viewForAnimation: UIView?) -> Bool {
        if let view = viewForAnimation {
            nonContaineeAnimatedViews.append(view)
            return true
        } else {
            return false
        }
    }
    
    func add(alongsideAnimation: ContextHandler?) -> Bool {
        if let animation = alongsideAnimation {
            animations.append(animation)
            return true
        } else {
            return false
        }
    }
    
    func add(completionBlock: ContextHandler?) -> Bool {
        if let completion = completionBlock {
            completionCallbacks.append(completion)
            return true
        } else {
            return false
        }
    }
}
