//
//  InteractiveTransition.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class HorizontalPanGestureInteractiveTransition: ContainerPercentDrivenInteractiveTransitioner {
    
    public typealias PanHandler = (UIPanGestureRecognizer) -> Void
    
    // MARK: Properties
    private let gestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private let progressNeeded: CGFloat
    private let velocityNeeded: CGFloat
    
    private var isLeftToRight = false
    private var shouldCompleteTransition = false
    private var lastVelocity = CGPoint.zero
    
    // This block gets run when the gesture recognizer starts recognizing a pan. Inside, the start of a transition can be triggered.
    private let gestureRecognizedBlock: PanHandler
    
    init(in view: UIView, progressThreshold: CGFloat = 0.35, velocityOverrideThreshold: CGFloat = 550, recognizedBlock: @escaping PanHandler) {
        self.progressNeeded = progressThreshold
        self.velocityNeeded = velocityOverrideThreshold
        self.gestureRecognizedBlock = recognizedBlock
        super.init()
        
        gestureRecognizer.addTarget(self, action: #selector(handlePan(recognizer:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning, using animator: UIViewControllerAnimatedTransitioning) {
        super.startInteractiveTransition(transitionContext, using: animator)
        isLeftToRight = gestureRecognizer.velocity(in: gestureRecognizer.view).x > 0
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else { return }
        
        switch recognizer.state {
        case .began: gestureRecognizedBlock(recognizer)
        case .changed:
            guard transitionContext != nil else {
                /*If the transition context doesn't exist, we haven't been given it - we aren't using a compatible animator. The container will only ask for an interaction controller and configure it if you provide it with a custom animator. */
                return
            }

            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            lastVelocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
            
            if (isLeftToRight && lastVelocity.x < 0) || (!isLeftToRight && lastVelocity.x > 0) {
                lastVelocity = .zero
            }
            
            //If we are back to the starting point, cancel the interaction and transition
            if (isLeftToRight && translation.x < 0) || (!isLeftToRight && translation.x > 0) {
                shouldCompleteTransition = false
                update(percentComplete: 0)
                return cancel()
            }
            
            let progress = abs(translation.x / recognizerView.bounds.width)
            shouldCompleteTransition = progress > progressNeeded || abs(lastVelocity.x) > velocityNeeded
            update(percentComplete: progress)
            
        default:
            shouldCompleteTransition ? finish() : cancel()
            shouldCompleteTransition = false
        }
    }
}
