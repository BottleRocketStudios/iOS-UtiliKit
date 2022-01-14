//
//  ActiveLabelViewController.swift
//  UtiliKit-iOS
//
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class ActiveLabelViewController: UIViewController {

    @IBOutlet private var activeLabels: [ActiveLabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeLabels.forEach { $0.text = nil } 
    }
}
