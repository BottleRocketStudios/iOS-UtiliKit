//
//  ContainerViewControllerTransitionCoordinator.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/// The `ContainerViewControllerTransitionCoordinator` is intended to closely mimic the `UIViewControllerTransitionCoordinator` protocol, with the exception that alongside animations must occur in the container of the transition and can not occur outside.
public protocol ContainerViewControllerTransitionCoordinator: UIViewControllerTransitionCoordinatorContext {
    
    @discardableResult
    func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
                 completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)?) -> Bool
    
    func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void)
    func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void)
}

/// This class is internal to the framework. Its concrete class type is never leaked and is instead exposed simply as an object conforming to `ContainerViewControllerTransitionCoordinator`. Its purpose is to function as a drop in replacement for the transition coordinator objects vended by UIKit for presentations. Because the container utilizes its own child-based transition environment, UIKit will not create a transition coordinator for its transitions.
class ContainerTransitionCoordinator: NSObject, ContainerViewControllerTransitionCoordinator {
    
    private static let defaultCompletionVelocity: CGFloat = 1.0
    private static let defaultCompletionCurve = UIView.AnimationCurve.easeInOut
    
    // MARK: Properties
    private let context: ContainerTransitionContext
    private let animator: UIViewControllerAnimatedTransitioning
    private let interactor: ContainerViewControllerInteractiveTransitioning?
    private var interruptibleAnimator: UIViewImplicitlyAnimating
    
    // MARK: Initializers
    init?(context: ContainerTransitionContext, animator: UIViewControllerAnimatedTransitioning, interactor: ContainerViewControllerInteractiveTransitioning? = nil) {
        guard let interruptibleAnimator = animator.interruptibleAnimator?(using: context) else { return nil }
        
        self.context = context
        self.animator = animator
        self.interactor = interactor
        self.interruptibleAnimator = interruptibleAnimator
        self.context.isInteractive = (interactor != nil)
    }
    
    // MARK: UIViewControllerTransitionCoordinatorContext
    var isAnimated: Bool { return context.isAnimated }
    var presentationStyle: UIModalPresentationStyle { return context.presentationStyle }
    var initiallyInteractive: Bool { return interactor?.wantsInteractiveStart ?? false }
    var isInterruptible: Bool = true //This coordinator requires the usage of an UIViewImplicitlyAnimating interruptible animator, which by default is interruptible.
    var isInteractive: Bool { return context.isInteractive }
    var isCancelled: Bool { return context.transitionWasCancelled }
    var transitionDuration: TimeInterval { return interactor?.transitionAnimator?.transitionDuration(using: context) ?? 0 }
    var percentComplete: CGFloat { return context.percentComplete }
    var completionVelocity: CGFloat { return interactor?.completionSpeed ?? ContainerTransitionCoordinator.defaultCompletionVelocity }
    var completionCurve: UIView.AnimationCurve { return interactor?.completionCurve ?? ContainerTransitionCoordinator.defaultCompletionCurve }
    var containerView: UIView { return context.containerView }
    var targetTransform: CGAffineTransform { return context.targetTransform }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return context.viewController(forKey: key)
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return context.view(forKey: key)
    }
    
    // MARK: UIViewControllerTransitionCoordinatorContext
    func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
                 completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        interruptibleAnimator.addAnimations? { animation?(self) }
        interruptibleAnimator.addCompletion? { _ in completion?(self) }
        
        return true
    }
    
    func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        notifyWhenInteractionChanges(handler)
    }
    
    func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        interruptibleAnimator.addCompletion? { _ in handler(self) }
    }
}
