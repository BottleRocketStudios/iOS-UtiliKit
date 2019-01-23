//
//  ContainerPercentDrivenInteractiveTransition.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

/// This class is a superclass intended to implement the base functionality provided by 'UIViewControllerInteractiveTransitioning' and the concrete class 'UIPercentDrivenInteractiveTransition'. Because the container must vend it's own `UIViewControllerContextTransitioning` object, it can not rely on `UIPercentDrivenInteractiveTransition` as it uses a private variable to access the `UIViewControllerAnimatedTransitioning` object associated with it to drive the transition. This class provides the same basic functionality as `UIPercentDrivenInteractiveTransition` with an additional variable for the animator object which is used to drive the transition.
open class ContainerPercentDrivenInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {
    
    public enum State {
        case inactive
        case interacting
        case completing
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
        
        state = .completing
        transitionContext?.cancelInteractiveTransition()
    }
    
    open func finish() {
        guard state == .interacting else { return }
        
        state = .completing
        transitionContext?.finishInteractiveTransition()
    }
    
    // MARK: Helper
    open func interactiveTransitionCompleted() {
        state = .inactive
    }
}
