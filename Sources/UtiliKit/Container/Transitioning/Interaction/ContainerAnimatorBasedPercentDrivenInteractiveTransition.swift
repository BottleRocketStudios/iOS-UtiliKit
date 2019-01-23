//
//  ContainerAnimatorBasedPercentDrivenInteractiveTransition.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

/// This class implements the functionality required for `UIViewControllerInteractiveTransitioning`. In order to drive the interactive nature of the transition, it utilizes an interruptible, reversible `UIViewPropertyAnimator`.
open class ContainerAnimatorBasedPercentDrivenInteractiveTransition: ContainerPercentDrivenInteractiveTransition {
    
    // MARK: Properties
    var interruptibleAnimator: UIViewImplicitlyAnimating?
    open override var percentComplete: CGFloat {
        didSet { interruptibleAnimator?.fractionComplete = percentComplete }
    }
    
    // MARK: UIViewControllerInteractiveTransitioning
    open override func startInteractiveTransition(_ context: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(context)
        
        guard let animator = transitionAnimator?.interruptibleAnimator?(using: context) else { return }
        interruptibleAnimator = animator
        
        animator.pauseAnimation()
        animator.addCompletion? { [weak self] position in
            self?.interactiveTransitionCompleted()
        }
    }
    
    open override func cancel() {
        super.cancel()
        interruptibleAnimator?.isReversed = true
        interruptibleAnimator?.continueAnimation?(withTimingParameters: nil, durationFactor: percentComplete)
    }
    
    open override func finish() {
        super.finish()
        interruptibleAnimator?.continueAnimation?(withTimingParameters: nil, durationFactor: (1 - percentComplete))
    }
    
    open func immediatelyFinishInteractiveTransition() {
        super.finish()
        interruptibleAnimator?.stopAnimation(false)
        interruptibleAnimator?.finishAnimation(at: .end)
    }
    
    open func immediatelyCancelInteractiveTransition() {
        super.cancel()
        interruptibleAnimator?.isReversed = true
        interruptibleAnimator?.stopAnimation(false)
        interruptibleAnimator?.finishAnimation(at: .end)
    }
    
    // MARK: Helper
    open override func interactiveTransitionCompleted() {
        super.interactiveTransitionCompleted()
        interruptibleAnimator = nil
    }
}
