//
//  ContainerViewControllerTransitionAnimator.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ContainerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.view(forKey: .from), let destination = transitionContext.view(forKey: .to) else { return }
        UIView.transition(from: source, to: destination, duration: transitionDuration(using: transitionContext), options: []) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
