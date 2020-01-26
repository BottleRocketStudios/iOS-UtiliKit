//
//  ContainerExampleViewController.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

extension ContainerViewController.Child.Identifier {
    static let a = ContainerViewController.Child.Identifier(rawValue: "A")
    static let b = ContainerViewController.Child.Identifier(rawValue: "B")
}

class BaseContainerViewController: UIViewController {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var aButton: UIButton!
    @IBOutlet private var bButton: UIButton!
    private lazy var containerViewController: ContainerViewController = {
        let container = ContainerViewController()
        container.delegate = self
        return container
    }()
    private var logLifecycleEvents = true
    private var useCustomAnimator = true
    private lazy var controllerA = ViewControllerA()
    private lazy var controllerB = ViewControllerB()
    
    private var interactionController: HorizontalPanGestureInteractiveTransition?
    private var animationController = WipeTransitionAnimator(direction: .leftToRight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        containerViewController.childManager.children = [.init(identifier: .a, viewController: controllerA),
                                                         .init(identifier: .b, viewController: controllerB)]

        //Configure the the container view controller
        containerViewController.willMove(toParent: self)
        addChild(containerViewController)
        containerView.addSubview(containerViewController.view)
        containerViewController.view.frame = containerView.bounds
        containerViewController.didMove(toParent: self)
        
        //Configure the interaction controller for the example
        interactionController = HorizontalPanGestureInteractiveTransition(in: view) { [weak self] recognizer in
            guard let self = self, let current = self.containerViewController.visibleChild else { return }
            
            if recognizer.velocity(in: recognizer.view).x > 0 {
                self.configureInteractiveTransitionToChild(preceding: current)
            } else {
                self.configureInteractiveTransitionToChild(following: current)
            }
        }
    }
    
    @IBAction func transitionToA() {
        interactionController?.wantsInteractiveStart = false
        containerViewController.transitionToExistingChild(with: .a)
    }
    
    @IBAction func transitionToB() {
        interactionController?.wantsInteractiveStart = false
        containerViewController.transitionToExistingChild(with: .b)
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

// MARK: Helper
private extension BaseContainerViewController {
    
    func configureInteractiveTransitionToChild(preceding visible: ContainerViewController.Child) {
        guard let previousChild = containerViewController.childManager.existingChild(.preceeding, child: visible) else { return }
        animationController.transitionDirection = .leftToRight
        containerViewController.transition(to: previousChild)
    }
    
    func configureInteractiveTransitionToChild(following visible: ContainerViewController.Child) {
        guard let nextChild = containerViewController.childManager.existingChild(.following, child: visible) else { return }
        animationController.transitionDirection = .rightToLeft
        containerViewController.transition(to: nextChild)
    }
}

//MARK: ContainerViewControllerDelegate
extension BaseContainerViewController: ContainerViewControllerDelegate {
    
    func containerViewController(_ container: ContainerViewController, didBeginTransitioningFrom source: UIViewController, to destination: UIViewController) {
        container.containerTransitionCoordinator?.animate(alongsideTransition: { context in
            self.aButton.transform = self.aButton.transform == .identity ? CGAffineTransform(scaleX: 2, y: 2) : .identity
            self.bButton.transform = self.bButton.transform == .identity ? CGAffineTransform(scaleX: 2, y: 2) : .identity
        }, completion: nil)
        
        container.containerTransitionCoordinator?.notifyWhenInteractionEnds { [weak self] context in
            self?.interactionController?.wantsInteractiveStart = true
        }
        
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
    
    func containerViewController(_ container: ContainerViewController, animationControllerForTransitionFrom source: UIViewController,
                                 to destination: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if useCustomAnimator, let sourceIndex = container.childManager.firstIndex(where: { $0.viewController === source }),
            let destinationIndex = container.childManager.firstIndex(where: { $0.viewController === destination }) {
            
            animationController.configure(forStartIndex: sourceIndex, endIndex: destinationIndex)
            return animationController
        }
        
        return nil
    }
    
    func containerViewController(_ container: ContainerViewController, interactionControllerForTransitionFrom source: UIViewController, to destination: UIViewController) -> ContainerViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
