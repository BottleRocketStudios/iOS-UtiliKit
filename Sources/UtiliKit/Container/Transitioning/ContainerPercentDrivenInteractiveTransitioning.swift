//
//  ContainerPercentDrivenInteractiveTransition2.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol ContainerPercentDrivenInteractiveTransitioning: UIViewControllerInteractiveTransitioning {
    var wantsInteractiveStart: Bool { get }
    var transitionAnimator: ContainerViewControllerAnimatedTransitioning? { get }
    var transitionContext: UIViewControllerContextTransitioning? { get }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning, using animator: ContainerViewControllerAnimatedTransitioning)
}

open class ContainerPercentDrivenInteractiveTransitioner: NSObject, ContainerPercentDrivenInteractiveTransitioning {

    // MARK: Properties
    open var transitionAnimator: ContainerViewControllerAnimatedTransitioning?
    open private(set) var transitionContext: UIViewControllerContextTransitioning?
    private(set) var interruptibleAnimator: UIViewImplicitlyAnimating?
    
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
        assertionFailure("In order to ensure present of the animator, use startInteractiveTransition(_:using:) instead.")
    }
    
    open func startInteractiveTransition(_ context: UIViewControllerContextTransitioning, using animator: ContainerViewControllerAnimatedTransitioning) {
        transitionContext = context
        transitionAnimator = animator
        interruptibleAnimator = animator.interruptibleAnimator(using: context)
                
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
