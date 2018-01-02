//
//  WipeTransitionAnimator.swift
//
//  Created by Wilson Turner on 2/17/17.
//

import UIKit

public class WipeTransitionAnimator: NSObject {
    
    public enum Direction {
        case leftToRight
        case rightToLeft
    }
    
    //MARK: Properties
    let transitionDirection: Direction
    
    //MARK: Initializers
    public init(direction: Direction) {
        self.transitionDirection = direction
        super.init()
    }
    
    public init(with startIndex: Int, endIndex: Int) {
        self.transitionDirection = startIndex < endIndex ? .rightToLeft : .leftToRight
        super.init()
    }
}

//MARK: UIViewControllerAnimatedTransitioning
extension WipeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.viewController(forKey: .to), let source = transitionContext.viewController(forKey: .from) else { return }
        let container = transitionContext.containerView
        
        container.addSubview(destination.view)
        destination.view.frame = transitionContext.finalFrame(for: destination)
        destination.view.transform = generateTransform(for: container, direction: transitionDirection, isSourceTransform: false)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            destination.view.transform = .identity
            source.view.transform = self.generateTransform(for: container, direction: self.transitionDirection, isSourceTransform: true)
        }, completion: { finished in
            source.view.transform = .identity
            source.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}

fileprivate extension WipeTransitionAnimator {
    
    func generateTransform(for containerView: UIView, direction: Direction, isSourceTransform: Bool) -> CGAffineTransform {
        let xPosition = isSourceTransform ? containerView.bounds.width : -containerView.bounds.width
        
        switch direction {
        case .leftToRight:
            return CGAffineTransform(translationX: xPosition, y: 0)
        case .rightToLeft:
            return CGAffineTransform(translationX: -xPosition, y: 0)
        }
    }
}
