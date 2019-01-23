//
//  InteractiveTransition.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import UtiliKit

public class HorizontalPanGestureInteractiveTransition: ContainerAnimatorBasedPercentDrivenInteractiveTransition {
    
    public typealias PanHandler = (UIPanGestureRecognizer) -> Void
    
    // MARK: Properties
    public let gestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private let progressNeeded: CGFloat
    private let velocityNeeded: CGFloat
    private var isLeftToRight = false
    
    private var shouldCompleteTransition = false
    private var lastVelocity = CGPoint.zero
    
    // This block gets run when the gesture recognizer start recognizing a pan. Inside, the start of a transition can be triggered.
    private let gestureRecognizedBlock: PanHandler
    
    public init(in view: UIView, progressThreshold: CGFloat = 0.35, velocityOverrideThreshold: CGFloat = 550, recognizedBlock: @escaping PanHandler) {
        self.progressNeeded = progressThreshold
        self.velocityNeeded = velocityOverrideThreshold
        self.gestureRecognizedBlock = recognizedBlock
        super.init()
        
        gestureRecognizer.addTarget(self, action: #selector(handlePan(recognizer:)))
        view.addGestureRecognizer(self.gestureRecognizer)
        
    }
    
    public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        isLeftToRight = gestureRecognizer.velocity(in: gestureRecognizer.view).x > 0
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else { return }
        
        switch recognizer.state {
        case .began: gestureRecognizedBlock(recognizer)
        case .changed:
            //Returning to the initial position can cancel the interaction, we should avoid that
            guard state != .tearDown else { return }

            //If it was cancelled and torn down, but panning continues, we restart it
            guard state == .interacting else { return gestureRecognizedBlock(recognizer) }
            guard transitionContext != nil else { assertionFailure("The transition context must exist at this point to perform a transition - logic error."); return }

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
            guard transitionContext != nil, state != .tearDown else { return }
            
            shouldCompleteTransition ? finish() : cancel()
            shouldCompleteTransition = false
        }
    }
}
