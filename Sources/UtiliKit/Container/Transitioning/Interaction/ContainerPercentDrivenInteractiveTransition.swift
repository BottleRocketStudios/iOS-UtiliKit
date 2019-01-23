//
//  ContainerPercentDrivenInteractiveTransition.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

open class ContainerPercentDrivenInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {
    
    public enum State {
        case inactive
        case interacting
        case tearDown
    }

    // MARK: Properties
    open var completionSpeed: CGFloat = 1
    open var completionCurve: UIView.AnimationCurve = .linear
    open var duration: CGFloat {
        return CGFloat(transitionAnimator?.transitionDuration(using: transitionContext) ?? 0)
    }
    open var percentComplete: CGFloat = 0 {
        didSet { transitionContext?.updateInteractiveTransition(percentComplete) }
    }
    
    open weak var transitionAnimator: UIViewControllerAnimatedTransitioning?
    open weak var transitionContext: UIViewControllerContextTransitioning?
    
    private(set) public var state: State = .inactive
    
    // MARK: Initializers
    public convenience init(animator: UIViewControllerAnimatedTransitioning) {
        self.init()
        transitionAnimator = animator
    }

    // MARK: UIViewControllerInteractiveTransitioning
    open func startInteractiveTransition(_ context: UIViewControllerContextTransitioning) {
        guard transitionAnimator != nil, state == .inactive else { return }
        
        state = .interacting
        transitionContext = context
    }
    
    open func update(percentComplete complete: CGFloat) {
        guard state == .interacting else { return }
        
        let normalizedPercent = min(1, max(0, complete))
        percentComplete = normalizedPercent
    }
    
    open func cancel() {
        guard state == .interacting else { return }
        
        state = .tearDown
        transitionContext?.cancelInteractiveTransition()
    }
    
    open func finish() {
        guard state == .interacting else { return }
        
        state = .tearDown
        transitionContext?.finishInteractiveTransition()
    }
    
    // MARK: Helper
    open func interactiveTransitionCompleted() {
        state = .inactive
    }
}
