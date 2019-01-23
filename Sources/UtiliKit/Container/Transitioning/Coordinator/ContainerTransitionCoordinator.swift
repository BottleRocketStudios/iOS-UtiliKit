//
//  ContainerTransitionCoordinator.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

//class ContainerTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {
//    
//    // MARK: Properties
//    private let context: UIViewControllerContextTransitioning
//    private let interruptibleAnimator: UIViewImplicitlyAnimating
//    private let transitionAnimator: UIViewControllerAnimatedTransitioning?
//    private let interactionController: ContainerPercentDrivenInteractiveTransition?
//    private var interactionChangeHandlers: [(UIViewControllerTransitionCoordinatorContext) -> Void] = []
//    
//    // MARK: Initializers
//    init?(context: UIViewControllerContextTransitioning, animator: UIViewControllerAnimatedTransitioning? = nil, interactionController: ContainerPercentDrivenInteractiveTransition? = nil) {
//        guard let interruptibleAnimator = interactionController?.transitionAnimator?.interruptibleAnimator?(using: context) ?? animator?.interruptibleAnimator?(using: context) else { return nil }
//        
//        self.context = context
//        self.interruptibleAnimator = interruptibleAnimator
//        self.transitionAnimator = animator
//        self.interactionController = interactionController
//        self.initiallyInteractive = (interactionController != nil)
//        super.init()
//        
//        self.interactionController?.transitionCoordinator = self
//    }
//    
//    // MARK: UIViewControllerTransitionCoordinatorContext
//    var isAnimated: Bool { return context.isAnimated }
//    var presentationStyle: UIModalPresentationStyle { return context.presentationStyle }
//    var initiallyInteractive: Bool
//    var isInterruptible: Bool { return true }
//    var isInteractive: Bool { return context.isInteractive }
//    var isCancelled: Bool { return context.transitionWasCancelled }
//    var transitionDuration: TimeInterval { return transitionAnimator?.transitionDuration(using: context) ?? 0 }
//    var percentComplete: CGFloat { return interruptibleAnimator.fractionComplete }
//    var completionVelocity: CGFloat { return interactionController?.completionSpeed ?? 1 }
//    var completionCurve: UIView.AnimationCurve { return interactionController?.completionCurve ?? .linear }
//    var containerView: UIView { return context.containerView }
//    var targetTransform: CGAffineTransform { return context.targetTransform }
//    
//    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
//        return context.viewController(forKey: key)
//    }
//    
//    func view(forKey key: UITransitionContextViewKey) -> UIView? {
//        return context.view(forKey: key)
//    }
//    
//    // MARK: UIViewControllerTransitionCoordinator
//    func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
//        interruptibleAnimator.addAnimations? { [unowned self] in animation?(self) }
//        interruptibleAnimator.addCompletion? { [unowned self] _ in completion?(self) }
//        return true
//    }
//    
//    func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
//        interruptibleAnimator.addAnimations? { [unowned self] in animation?(self) }
//        interruptibleAnimator.addCompletion? { [unowned self] _ in completion?(self) }
//        return true
//    }
//    
//    func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
//        notifyWhenInteractionChanges(handler)
//    }
//    
//    func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
//        interactionChangeHandlers.append(handler)
//    }
//}
//
//// MARK: Private
//extension ContainerTransitionCoordinator {
//    
//    func notifyInteractionChanged() {
//        interactionChangeHandlers.forEach { $0(self) }
//    }
//}
