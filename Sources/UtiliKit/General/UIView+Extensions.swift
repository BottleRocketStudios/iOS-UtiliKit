//
//  UIView+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UIView {
    
    /**
     Adds the given subview to the superview, optionally constraining it to the edges of its superview.
     
     - Parameter subview: The subview to add.
     - Parameter constrainedToSuperview: Whether or not you want the edges to be automatically constrained to the superview. If 'true', then 'translatesAutoresizingMaskIntoConstraints' will automatically be set to false for the given subview.
     - Parameter isUsingSafeArea: A Bool value used to determine the use of safeAreaLayoutGuides or superview anchors
    */
    @available(iOS 11, *)
    public func addSubview(_ subview: UIView, constrainedToSuperview: Bool, usingSafeArea isUsingSafeArea: Bool) {
        guard constrainedToSuperview else {
            addSubview(subview)
            return
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        subview.constrainEdgesToSuperview(usingSafeArea: isUsingSafeArea)
    }
    
    /**
     Adds the given subview to the superview, optionally constraining it to the edges of its superview.
     
     - Parameter subview: The subview to add.
     - Parameter constrainedToSuperview: Whether or not you want the edges to be automatically constrained to the superview. If 'true', then 'translatesAutoresizingMaskIntoConstraints' will automatically be set to false for the given subview.
     */
    public func addSubview(_ subview: UIView, constrainedToSuperview: Bool) {
        guard constrainedToSuperview else {
            addSubview(subview)
            return
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        subview.constrainEdgesToSuperview()
    }
    
    /**
     Constrains the receiver to the edges of its superview with insets. Default inset is zero.
     
     - Parameter insets: Defaults to UIEdgeInsets.zero, this parameter is used for the constant value of the constraints
     - Parameter isUsingSafeArea: A Bool value used to determine the use of safeAreaLayoutGuides or superview anchors
    */
    @available(iOS 11, *)
    public func constrainEdgesToSuperview(with insets: UIEdgeInsets = .zero, usingSafeArea isUsingSafeArea: Bool) {
        guard let superview = superview else { return }
        
        if isUsingSafeArea {
            superview.addConstraints([leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
                                      trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
                                      topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
                                      bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)])
        } else {
            constrainEdgesToSuperview(with: insets)
        }
    }
    
    /**
     Constrains the receiver to the edges of its superview with insets. Default inset is zero.
     
     - Parameter insets: Defaults to UIEdgeInsets.zero, this parameter is used for the constant value of the constraints
     */
    public func constrainEdgesToSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        
        superview.addConstraints([leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
                                  trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right),
                                  topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                                  bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom)])
    }
    
    /**
     Constrains the receiver to the edges of its superview with insets.
     
     - Parameter isUsingSafeArea: A Bool value used to determine the use of safeAreaLayoutGuides or superview anchors
     */
    @available(iOS 11, *)
    func centerViewInSuperview(usingSafeArea isUsingSafeArea: Bool) {
        guard let superview = superview else { return }
        
        if isUsingSafeArea {
            superview.addConstraints([centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
                                      centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)])
        } else {
            centerViewInSuperview()
        }
    }
    
    /// Constrains the receiver to the edges of its superview with insets.
    func centerViewInSuperview() {
        guard let superview = superview else { return }
        
        superview.addConstraints([centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                                  centerYAnchor.constraint(equalTo: superview.centerYAnchor)])
    }
}
