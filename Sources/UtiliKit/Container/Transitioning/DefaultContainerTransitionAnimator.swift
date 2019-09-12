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
        return 0.3
    }
    
     func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationController = transitionContext.viewController(forKey: .to),
            let destination = destinationController.view, let source = transitionContext.view(forKey: .from) else {
            fatalError("The context is improperly configured - requires both a source and destination.")
        }
        
        transitionContext.containerView.addSubview(destination)
        destination.frame = transitionContext.finalFrame(for: destinationController)
       
       UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
           source.alpha = 0
           destination.alpha = 1
       }) { _ in
           transitionContext.completeTransition(true)
       }
    }
}
