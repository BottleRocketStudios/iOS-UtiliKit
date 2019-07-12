//
//  ContainerViewControllerInteractiveAnimatedTransitioning.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 7/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol ContainerViewControllerInteractiveTransitioning {
    
    var wantsInteractiveStart: Bool { get }
    var completionSpeed: CGFloat { get }
    var completionCurve: UIView.AnimationCurve { get }
    
    var transitionAnimator: UIViewControllerAnimatedTransitioning? { get }
    var transitionContext: UIViewControllerContextTransitioning? { get }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning, using animator: UIViewControllerAnimatedTransitioning)
}

public struct ContainerViewControllerInteractiveAnimator {
    
    // MARK: Properties
    public let animator: UIViewControllerAnimatedTransitioning
    public let interactor: ContainerViewControllerInteractiveTransitioning
    
    // MARK: Initializer
    public init(animator: UIViewControllerAnimatedTransitioning, interactor: ContainerViewControllerInteractiveTransitioning) {
        self.animator = animator
        self.interactor = interactor
    }
}

