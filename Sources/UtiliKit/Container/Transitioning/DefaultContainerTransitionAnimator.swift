//
//  ContainerViewControllerTransitionAnimator.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/// This class is internal to the framework. It is the internal default transition animator used by the ContainerViewController when its delegate does not provide one.
class DefaultContainerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationController = transitionContext.viewController(forKey: .to), let destination = destinationController.view else {
            fatalError("The context is improperly configured - requires both a source and destination.")
        }
        
        transitionContext.containerView.addSubview(destination)
        destination.frame = transitionContext.finalFrame(for: destinationController)
        transitionContext.completeTransition(true)
    }
}
