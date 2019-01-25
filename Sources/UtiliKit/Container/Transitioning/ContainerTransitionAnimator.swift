//
//  ContainerViewControllerTransitionAnimator.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ContainerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var interruptibleAnimator: UIViewPropertyAnimator?
  
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
        
        let propertyAnimator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        propertyAnimator.addAnimations { [unowned self] in
            UIView.transition(from: source, to: destination, duration: self.transitionDuration(using: transitionContext), options: [.transitionCrossDissolve]) { finished in
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
