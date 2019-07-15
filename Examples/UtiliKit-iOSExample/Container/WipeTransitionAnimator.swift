//
//  WipeTransitionAnimator.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit


/// The `WipeTransitionAnimator` enables the transition from one `UIViewController` object to another by pushing the source off the screen revealing the destination. The transition supports wiping from both right to left and left to right and is powered by a `UIViewImplicitlyAnimating` object, allowing for interactivity.
class WipeTransitionAnimator: NSObject {
    
    enum Direction {
        case leftToRight
        case rightToLeft
    }
    
    //MARK: Properties
    var transitionDirection: Direction
    private var interruptibleAnimator: UIViewPropertyAnimator?
    private let duration = 0.3
    
    //MARK: Initializers
    init(direction: Direction) {
        self.transitionDirection = direction
        super.init()
    }
    
    convenience init(startIndex: Int, endIndex: Int) {
        self.init(direction: startIndex < endIndex ? .rightToLeft : .leftToRight)
    }
    
    // MARK: Interface
    func configure(forStartIndex startIndex: Int, endIndex: Int) {
        transitionDirection = startIndex < endIndex ? .rightToLeft : .leftToRight
    }
}

//MARK: UIViewControllerAnimatedTransitioning
extension WipeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator?.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animator = interruptibleAnimator {
            return animator
        }
        
        guard let destination = transitionContext.viewController(forKey: .to), let source = transitionContext.viewController(forKey: .from) else {
            fatalError("The context is improperly configured - requires both a source and destination.")
        }

        configureInitialState(for: destination, with: transitionContext)
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let propertyAnimator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: timingParameters)
        propertyAnimator.addAnimations { [weak self] in
            self?.configureFinalState(forSource: source, destination: destination, context: transitionContext)
        }
        
        propertyAnimator.addCompletion { [weak self] animatingPosition in
            self?.completeAnimation(successfully: animatingPosition == .end, for: source, destination: destination, with: transitionContext)
            self?.interruptibleAnimator = nil
        }
    
        interruptibleAnimator = propertyAnimator
        return propertyAnimator
    }
}

// MARK: Helper
private extension WipeTransitionAnimator {
    
    func configureInitialState(for destination: UIViewController, with context: UIViewControllerContextTransitioning) {
        context.containerView.addSubview(destination.view)
        destination.view.frame = context.finalFrame(for: destination)
        destination.view.transform = transform(for: context.containerView, direction: transitionDirection, isSourceTransform: false)
    }
    
    func configureFinalState(forSource source: UIViewController, destination: UIViewController, context: UIViewControllerContextTransitioning) {
        destination.view.transform = .identity
        source.view.transform = transform(for: context.containerView, direction: transitionDirection, isSourceTransform: true)
    }
    
    func completeAnimation(successfully: Bool, for source: UIViewController, destination: UIViewController, with context: UIViewControllerContextTransitioning) {
        if successfully {
            //We successfully FINISHED the transition - reset and remove the source
            source.view.transform = .identity
            source.view.removeFromSuperview()
        } else {
            //The transition failed or was CANCELLED - reset and remove the destination
            destination.view.transform = .identity
            destination.view.removeFromSuperview()
        }
        
        context.completeTransition(successfully && !context.transitionWasCancelled)
    }
    
    func transform(for containerView: UIView, direction: Direction, isSourceTransform: Bool) -> CGAffineTransform {
        let xPosition = isSourceTransform ? containerView.bounds.width : -containerView.bounds.width
        return CGAffineTransform(translationX: xPosition * (direction == .rightToLeft ? -1 : 1), y: 0)
    }
}
