//
//  ViewControllerA.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class ViewControllerA: UIViewController {
    
    var logLifecycleEvents: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        logEvent("View A Did Load")
        
        let newView = UILabel(frame: .zero)
        newView.text = "A"
        newView.textAlignment = .center
        newView.font = UIFont.systemFont(ofSize: 100)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = .yellow
        
        view.addSubview(newView)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([newView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                         newView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                         newView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                         newView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
        } else {
            NSLayoutConstraint.activate([newView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                         newView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
                                         newView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
                                         newView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logEvent("View A Will Appear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logEvent("View A Will Layout Subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logEvent("View A Did Layout Subviews")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logEvent("View A Did Appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logEvent("View A Did Disappear")
    }
    
    func logEvent(_ message: String) {
        if logLifecycleEvents {
            debugPrint(message)
        }
    }
}
