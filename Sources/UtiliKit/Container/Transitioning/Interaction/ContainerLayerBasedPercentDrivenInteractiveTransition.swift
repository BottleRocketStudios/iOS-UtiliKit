//
//  ContainerLayerDrivenPercentInteractiveTransition.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

open class ContainerLayerBasedPercentDrivenInteractiveTransition: ContainerPercentDrivenInteractiveTransition {
    
    // MARK: Properties
    private var displayLink: CADisplayLink?
    open override var percentComplete: CGFloat {
        didSet { timeOffset = TimeInterval(percentComplete * duration) }
    }
    private var timeOffset: TimeInterval {
        set { transitionContext?.containerView.layer.timeOffset = newValue }
        get { return transitionContext?.containerView.layer.timeOffset ?? 0 }
    }

    // MARK: UIViewControllerInteractiveTransitioning
    open override func startInteractiveTransition(_ context: UIViewControllerContextTransitioning) {
        guard state == .inactive else { return }
        
        super.startInteractiveTransition(context)
        context.containerView.layer.speed = 0
        transitionAnimator?.animateTransition(using: context)
    }
    
    open override func cancel() {
        super.cancel()
        completeTransition()
    }
    
    open override func finish() {
        super.finish()
        self.completeTransition()
    }
}

// MARK: Private
private extension ContainerLayerBasedPercentDrivenInteractiveTransition {
    
    func completeTransition() {
        displayLink = CADisplayLink(target: self, selector: #selector(animationTickHandler))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc func animationTickHandler() {
        let tick = (displayLink?.duration ?? 0) * CFTimeInterval(completionSpeed)
        let timeOffset = self.timeOffset + ((transitionContext?.transitionWasCancelled ?? true) ? -tick : tick)
        
        if timeOffset < 0 || timeOffset > TimeInterval(duration) {
            transitionFinished()
        } else {
            self.timeOffset = timeOffset
        }
    }
    
    func transitionFinished() {
        guard let layer = transitionContext?.containerView.layer else { return }
        
        displayLink?.invalidate()
        layer.speed = 1
        
        if transitionContext?.transitionWasCancelled == false {
            layer.timeOffset = 0
            layer.beginTime = 0
        }
        
        super.interactiveTransitionCompleted()
    }
}
