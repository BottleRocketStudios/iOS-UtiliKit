//
//  ContainerPercentDrivenInteractiveTransition2.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol ContainerPercentDrivenInteractiveTransitioning: UIViewControllerInteractiveTransitioning {
    var transitionAnimator: UIViewControllerAnimatedTransitioning? { get }
    var transitionContext: UIViewControllerContextTransitioning? { get }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning, animator: UIViewControllerAnimatedTransitioning)
}

open class ContainerPercentDrivenInteractiveTransitioner: NSObject, ContainerPercentDrivenInteractiveTransitioning {

    // MARK: Properties
    open var transitionAnimator: UIViewControllerAnimatedTransitioning?
    open private(set) var transitionContext: UIViewControllerContextTransitioning?
    var interruptibleAnimator: UIViewImplicitlyAnimating?
    
    // MARK: Internal State
    open var percentComplete: CGFloat = 0.0 {
        didSet { interruptibleAnimator?.fractionComplete = percentComplete }
    }
    
    open var completionSpeed: CGFloat = 1.0
    open var completionCurve: UIView.AnimationCurve = .easeInOut
    open lazy var timingCurve: UITimingCurveProvider = UICubicTimingParameters(animationCurve: completionCurve)
    
    open var wantsInteractiveStart: Bool = true
    
    // MARK: ContainerPercentDrivenInteractiveTransitioning
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        /* No op - startInteractiveTransition(_:animator:) will be called instead */
    }
    
    open func startInteractiveTransition(_ context: UIViewControllerContextTransitioning, animator: UIViewControllerAnimatedTransitioning) {
        transitionContext = context
        transitionAnimator = animator
        interruptibleAnimator = animator.interruptibleAnimator?(using: context)
        
        assert(interruptibleAnimator != nil, "In order for a transition to be interactive, the UIViewControllerAnimatedTransitioning object must implemented interruptibleAnimator(using:)")
        
        interruptibleAnimator?.addCompletion? { [weak self] _ in
            self?.interruptibleAnimator = nil
        }
    }
    
    open func pause() {
        transitionContext?.pauseInteractiveTransition()
        interruptibleAnimator?.pauseAnimation()
    }
    
    // MARK: Interface
    open func update(percentComplete complete: CGFloat) {
        let normalized = min(1, max(0, complete))
        
        transitionContext?.updateInteractiveTransition(normalized)
        percentComplete = normalized
    }
    
    /// Cancel the interactive transition, instructing the transition to return to it's initial state.
    open func cancel() {
        transitionContext?.cancelInteractiveTransition()
        
        interruptibleAnimator?.isReversed = true
        interruptibleAnimator?.continueAnimation?(withTimingParameters: timingCurve, durationFactor: percentComplete)
    }
    
    /// Finish the transition through animation, instructing the transition to complete it's movement to the destination view controller.
    open func finish() {
        transitionContext?.finishInteractiveTransition()
        interruptibleAnimator?.continueAnimation?(withTimingParameters: timingCurve, durationFactor: 1 - percentComplete)
    }
}
