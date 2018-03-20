//
//  ViewController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/**
 Example view controller showcasing how to programmatically instantiate a XibView.
 
 By simply defining the type and calling instanceFromNib we are able to instantiate our view in only a line, no casting needed
 */
class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.subviews.forEach { $0.removeFromSuperview() }
        // Instantiate a "XibView" from it's Xib
        // Notice that the desired type of view that you want to instantiate must be provided.
        // The NibLoadable protocol conformance will automatically attempt to instantiate a view with a nib name that matches the name of the view's type and then cast it into that type.
        let xibView: XibView = XibView.instanceFromNib()
        xibView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        xibView.center = view.center
        view.addSubview(xibView)
    }
}
