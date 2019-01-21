//
//  ContainerTransitionCoordinator.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 1/21/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class ContainerTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {
    
    public var isAnimated: Bool = true
    
    public var presentationStyle: UIModalPresentationStyle = .custom
    
    public var initiallyInteractive: Bool = true
    
    public var isInterruptible: Bool  = true
    
    public var isInteractive: Bool  = true
    
    public var isCancelled: Bool  = true
    
    public var transitionDuration: TimeInterval = 0.0
    
    public var percentComplete: CGFloat = 1.0
    
    public var completionVelocity: CGFloat = 1.0
    
    public var completionCurve: UIView.AnimationCurve = .linear
    
    public func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return nil
    }
    
    public func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return nil
    }
    
    public var containerView: UIView = UIView()
    
    public var targetTransform: CGAffineTransform = .identity
    
    public func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        return false
    }
    
    public func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        return false
    }
    
    public func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        //
    }
    
    public func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        //
    }
}
