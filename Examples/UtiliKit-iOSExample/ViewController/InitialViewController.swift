//
//  InitialViewController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

/**
 A simple view controller used in the example showcasing how to programmatically instantiate view controllers.
 
 Check out VCViewController and UIStoryboardIdentifier+Extensions.swift to see how the view controllers and storyboards are instantiated in a type-safe fashion.
 */
class InitialViewController: UIViewController, Configurable {
    
    @IBAction func didSelectClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func configure(with element: String) {
        /* No op */
    }
}
