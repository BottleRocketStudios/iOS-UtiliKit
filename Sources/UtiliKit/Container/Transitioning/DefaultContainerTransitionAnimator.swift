//
//  ContainerViewControllerTransitionAnimator.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/// This class is internal to the framework. It is the internal default transition animator used by the ContainerViewController when it's delegate does not provide one.
class DefaultContainerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: Properties
    private var interruptibleAnimator: UIViewPropertyAnimator?
    
    // MARK: ContainerViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator?.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let destination = transitionContext.view(forKey: .to), let source = transitionContext.view(forKey: .from) else {
            fatalError("The context is improperly configured - requires both a source and destination.")
        }
        
        if let animator = interruptibleAnimator {
            return animator
        }
        
        let duration = transitionDuration(using: transitionContext)
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        propertyAnimator.addAnimations {
            UIView.transition(from: source, to: destination, duration: duration, options: [.transitionCrossDissolve]) { finished in
                transitionContext.completeTransition(finished)
            }
        }
        
        propertyAnimator.addCompletion { [weak self] animatingPosition in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self?.interruptibleAnimator = nil
        }
        
        interruptibleAnimator = propertyAnimator
        return propertyAnimator
    }
}
