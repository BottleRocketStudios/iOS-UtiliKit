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
    
    /// completionSpeed defaults to 1.0 which corresponds to a completion duration of
    /// (1 - percentComplete)*duration.  It must be greater than 0.0. The actual
    /// completion is inversely proportional to the completionSpeed.  This can be set
    /// before cancelInteractiveTransition or finishInteractiveTransition is called
    /// in order to speed up or slow down the non interactive part of the
    /// transition.
    open var completionSpeed: CGFloat = 1
    
    /// When the interactive part of the transition has completed, this property can
    /// be set to indicate a different animation curve. It defaults to UIViewAnimationCurveEaseInOut.
    /// Note that during the interactive portion of the animation the timing curve is linear.
    open var completionCurve: UIView.AnimationCurve = .easeInOut
    
    /// This is the non-interactive duration that was returned when the
    /// animators transitionDuration: method was called when the transition started.
    open var duration: CGFloat {
        return CGFloat(transitionAnimator?.transitionDuration(using: transitionContext) ?? 0)
    }
    
    /// The last percentComplete value specified by updateInteractiveTransition:
    open var percentComplete: CGFloat = 0 {
        didSet { transitionContext?.updateInteractiveTransition(percentComplete) }
    }
    
    /// The animator object used to drive the transition. It will be linearly interpolated using the gesture powering the interactive portion of the transition, and will continue to completion once interaction has ended.
    open weak var transitionAnimator: UIViewControllerAnimatedTransitioning?
    
    /// The context used to configure the transition.
    open weak var transitionContext: UIViewControllerContextTransitioning?
    
    /// The current state of the transition - inactive, interacting or completing (animating).
    private(set) public var state: State = .inactive
    
    // MARK: Initializers
    public convenience init(animator: UIViewControllerAnimatedTransitioning) {
        self.init()
        transitionAnimator = animator
    }

    // MARK: UIViewControllerInteractiveTransitioning
    
    /// Starts an interactive transition. Sets up the animation for the transition, allowing the user to step through it by supplying different 'percentComplete' values to update(:)
    ///
    /// - Parameter context: The context used to configure the transition
    open func startInteractiveTransition(_ context: UIViewControllerContextTransitioning) {
        guard transitionAnimator != nil, state == .inactive else { return }
        
        state = .interacting
        transitionContext = context
    }
    
    /// Update the state of the transition to a new percentage. Allowing the object to drive the underlying transition animator to a new visual state.
    ///
    /// - Parameter complete: The completion percentage of the transition. A floating point value from 0.0-1.0.
    open func update(percentComplete complete: CGFloat) {
        guard state == .interacting else { return }
        
        let normalizedPercent = min(1, max(0, complete))
        percentComplete = normalizedPercent
    }
    
    /// Cancel the interactive transition, instructing the transition to return to it's initial state.
    open func cancel() {
        guard state == .interacting else { return }
        
        state = .completing
        transitionContext?.cancelInteractiveTransition()
    }
    
    /// Finish the transition through animation, instructing the transition to complete it's movement to the destination view controller.
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
