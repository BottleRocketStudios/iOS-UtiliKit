//
//  ContainerExampleViewController.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class BaseContainerViewController: UIViewController {
    
    @IBOutlet private var containerView: UIView!
    private lazy var containerViewController: ContainerViewController = {
        let container = ContainerViewController()
        container.delegate = self
        return container
    }()
    private var logLifecycleEvents = true
    private var useCustomAnimator = true
    private lazy var controllerA = ViewControllerA()
    private lazy var controllerB = ViewControllerB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        containerViewController.managedChildren = [Child(title: "A", viewController: controllerA),
                                                   Child(title: "B", viewController: controllerB)]

        containerViewController.willMove(toParent: self)
        addChild(containerViewController)
        containerView.addSubview(containerViewController.view)
        containerViewController.view.frame = containerView.bounds
        containerViewController.didMove(toParent: self)
    }
    
    @IBAction func transitionToA() {
        containerViewController.transitionToController(withTitle: "A")
    }
    
    @IBAction func transitionToB() {
        containerViewController.transitionToController(withTitle: "B")
    }
    
    @IBAction func logSwitchDidChange(_ sender: UISwitch) {
        controllerA.logLifecycleEvents = sender.isOn
        controllerB.logLifecycleEvents = sender.isOn
        logLifecycleEvents = sender.isOn
    }
    
    @IBAction func useCustomAnimatorSwitchDidChange(_ sender: UISwitch) {
        useCustomAnimator = sender.isOn
    }
}

//MARK: Helper
fileprivate extension ContainerViewController {
    func transitionToController(withTitle title: String) {
        //Note: As titles can change rapidly, it is much safer to directly use the Child object.
        guard let child = managedChildren.first(where: { $0.title == title }) else { return }
        transitionToController(for: child)
    }
}

//MARK: ContainerViewControllerDelegate
extension BaseContainerViewController: ContainerViewControllerDelegate {
    
    func containerViewController(_ container: ContainerViewController, didBeginTransitioningFrom source: UIViewController, to destination: UIViewController) {
        if logLifecycleEvents {
            debugPrint("Did Begin Transitioning from: \(source) to: \(destination)")
        }
    }
    
    func containerViewController(_ container: ContainerViewController, didFinishTransitioningFrom source: UIViewController, to destination: UIViewController) {
        if logLifecycleEvents {
            debugPrint("Did End Transitioning from: \(source) to: \(destination)")
        }
    }
    
    func containerViewController(_ container: ContainerViewController, shouldTransitionFrom source: UIViewController, to destination: UIViewController) -> Bool {
        return true
    }
    
    func containerViewController(_ container: ContainerViewController,
                                 animationControllerForTransitionFrom source: UIViewController,
                                 to destination: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if useCustomAnimator, let sourceIndex = container.index(ofChild: source), let destinationIndex = container.index(ofChild: destination) {
            return WipeTransitionAnimator(withStartIndex: sourceIndex, endIndex: destinationIndex)
        }
        
        return nil
    }
}
