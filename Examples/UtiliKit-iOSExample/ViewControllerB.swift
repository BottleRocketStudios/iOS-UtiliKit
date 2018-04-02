//
//  ViewControllerB.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {
    
    var logLifecycleEvents: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        logEvent("View B Did Load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logEvent("View B Did Appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logEvent("View B Did Disappear")
    }
    
    func logEvent(_ message: String) {
        if logLifecycleEvents {
            print(message)
        }
    }
}
