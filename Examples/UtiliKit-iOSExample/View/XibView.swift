//
//  XibView.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/**
 A simple view used in the example showcasing how to programmatically instantiate views that are attached to a XIB.
 
 Check out ViewController to see how the views are instantiated in a type-safe fashion.
 */
class XibView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}
