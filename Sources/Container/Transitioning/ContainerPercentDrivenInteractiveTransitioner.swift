//
//  ContainerPercentDrivenInteractiveTransitioner.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/24/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import UIKit

open class ContainerPercentDrivenInteractiveTransitioner: NSObject, ContainerViewControllerInteractiveTransitioning {

    // MARK: Properties
    open var transitionAnimator: UIViewControllerAnimatedTransitioning?
    open private(set) var transitionContext: UIViewControllerContextTransitioning?
    private(set) var interruptibleAnimator: UIViewImplicitlyAnimating?
    
    // MARK: Internal State
    open var percentComplete: CGFloat = 0.0 {
        didSet { interruptibleAnimator?.fractionComplete = percentComplete }
    }
    
    open var wantsInteractiveStart: Bool = true
    open var completionSpeed: CGFloat = 1.0
    open var completionCurve: UIView.AnimationCurve = .easeInOut
    open lazy var timingCurve: UITimingCurveProvider = UICubicTimingParameters(animationCurve: completionCurve)
    
    // MARK: ContainerPercentDrivenInteractiveTransitioning
    open func startInteractiveTransition(_ context: UIViewControllerContextTransitioning, using animator: UIViewControllerAnimatedTransitioning) {
        transitionContext = context
        transitionAnimator = animator
        
        guard let animator = animator.interruptibleAnimator?(using: context) else {
            return debugPrint("In order to fully use the \(ContainerPercentDrivenInteractiveTransitioner.self), the animator must provide an object conforming to \(UIViewImplicitlyAnimating.self).")
        }
    
        interruptibleAnimator = animator
        interruptibleAnimator?.addCompletion? { [weak self] _ in
            self?.interruptibleAnimator = nil
        }
    }
    
    open func pause() {
        transitionContext?.pauseInteractiveTransition()
        interruptibleAnimator?.pauseAnimation()
    }
    
    // MARK: Interface
    
    /// Scrub through the interactive transition, updating the context at each step
    open func update(percentComplete complete: CGFloat) {
        let normalized = min(1, max(0, complete))
        
        transitionContext?.updateInteractiveTransition(normalized)
        percentComplete = normalized
    }
    
    /// Cancel the interactive transition, instructing the transition to return to its initial state.
    open func cancel() {
        transitionContext?.cancelInteractiveTransition()
        
        interruptibleAnimator?.isReversed = true
        interruptibleAnimator?.continueAnimation?(withTimingParameters: timingCurve, durationFactor: percentComplete)
    }
    
    /// Finish the transition through animation, instructing the transition to complete its movement to the destination view controller.
    open func finish() {
        transitionContext?.finishInteractiveTransition()
        interruptibleAnimator?.continueAnimation?(withTimingParameters: timingCurve, durationFactor: 1 - percentComplete)
    }
}
