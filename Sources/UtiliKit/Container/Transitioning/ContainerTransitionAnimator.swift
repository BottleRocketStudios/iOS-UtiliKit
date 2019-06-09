//
//  ContainerViewControllerTransitionAnimator.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public protocol ContainerViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {

    /// A conforming object implements this method if the transition it creates can
    /// be interrupted. For example, it could return an instance of a
    /// UIViewPropertyAnimator. It is expected that this method will return the same
    /// instance for the life of a transition.
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating
}

class ContainerTransitionAnimator: NSObject, ContainerViewControllerAnimatedTransitioning {
    
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
        if let animator = interruptibleAnimator {
            return animator
        }
        
        guard let destination = transitionContext.view(forKey: .to), let source = transitionContext.view(forKey: .from) else {
            fatalError("The context is improperly configured - require both a source and destination.")
        }
        
        let duration = transitionDuration(using: transitionContext)
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        propertyAnimator.addAnimations {
            UIView.transition(from: source, to: destination, duration: duration, options: [.transitionCrossDissolve]) { finished in
                transitionContext.completeTransition(finished)
            }
        }
        
        propertyAnimator.addCompletion { [unowned self] animatingPosition in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.interruptibleAnimator = nil
        }
        
        interruptibleAnimator = propertyAnimator
        return propertyAnimator
    }
}
