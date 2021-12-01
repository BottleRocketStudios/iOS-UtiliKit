//
//  VCViewController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

/**
 Example view controller showcasing how to programmatically instantiate view controllers using only a Storyboard.Identifier.
 Check out how InitialViewController and NamedViewController are instantiated in the actions below.
 Then check out the extension on UIStoryboard.Identifier.
 */
class VCViewController: UIViewController {
    
    @IBAction func didSelectInitialViewController(_ sender: Any) {
        // Instantiate an InitialViewController from the storyboard
        // Notice that the desired type of view controller that you want to instantiate must be provided.
        // The UIStoryboard extension will automatically attempt to instantiate a view controller with an identifier that matches the name of the view controller's type and then cast it into that type.
        let vc: InitialViewController = UIStoryboard(identifier: .vcTest).instantiateInitialViewController(configuredWith: "string")
        present(vc, animated: true)
    }
    
    @IBAction func didSelectNamedViewController(_ sender: Any) {
        let vc: NamedViewController = UIStoryboard(identifier: .vcTest).instantiateViewController()
        present(vc, animated: true)
    }
}
