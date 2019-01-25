//
//  ContainerTransitionCoordinator.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ContainerTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {
    
    private static let defaultCompletionVelocity: CGFloat = 1.0
    private static let defaultCompletionCurve = UIView.AnimationCurve.easeInOut
    
    // MARK: Properties
    private let context: ContainerTransitionContext
    private let animator: UIViewControllerAnimatedTransitioning
    private let interactionController: ContainerPercentDrivenInteractiveTransitioning?
    private var interruptibleAnimator: UIViewImplicitlyAnimating
    
    // MARK: Initializers
    init?(context: ContainerTransitionContext, animator: UIViewControllerAnimatedTransitioning, interactionController: ContainerPercentDrivenInteractiveTransitioning? = nil) {
        guard let interruptibleAnimator = animator.interruptibleAnimator?(using: context) else { return nil }
        
        self.context = context
        self.animator = animator
        self.interactionController = interactionController
        self.interruptibleAnimator = interruptibleAnimator
    }
    
    // MARK: UIViewControllerTransitionCoordinatorContext
    var isAnimated: Bool { return context.isAnimated }
    var presentationStyle: UIModalPresentationStyle { return context.presentationStyle }
    var initiallyInteractive: Bool { return interactionController?.wantsInteractiveStart ?? false }
    var isInterruptible: Bool = true //This coordinator requires the usage of an UIViewImplicitlyAnimating interruptible animator, which by default is interruptible.
    var isInteractive: Bool { return context.isInteractive }
    var isCancelled: Bool { return context.transitionWasCancelled }
    var transitionDuration: TimeInterval { return interactionController?.transitionAnimator?.transitionDuration(using: context) ?? 0 }
    var percentComplete: CGFloat { return context.percentComplete }
    var completionVelocity: CGFloat { return interactionController?.completionSpeed ?? ContainerTransitionCoordinator.defaultCompletionVelocity }
    var completionCurve: UIView.AnimationCurve { return interactionController?.completionCurve ?? ContainerTransitionCoordinator.defaultCompletionCurve }
    var containerView: UIView { return context.containerView }
    var targetTransform: CGAffineTransform { return context.targetTransform }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return context.viewController(forKey: key)
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return context.view(forKey: key)
    }
    
    // MARK: UIViewControllerTransitionCoordinatorContext
    func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        interruptibleAnimator.addAnimations? { animation?(self) }
        interruptibleAnimator.addCompletion? { _ in completion?(self) }
        
        return true
    }
    
    func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        //This is not yet supported
        return false
    }
    
    func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        notifyWhenInteractionChanges(handler)
    }
    
    func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        interruptibleAnimator.addCompletion? { _ in handler(self) }
    }
}
