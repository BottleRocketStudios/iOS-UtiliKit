//
//  ContainerViewController+ManagedChildren.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 8/1/18.
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension ContainerViewController {
    
    //MARK: Finding a ManagedChild
    func index(ofChild controller: UIViewController) -> Int? {
        return managedChildren.firstIndex(where: { $0.viewController === controller })
    }
    
    func child(following viewController: UIViewController) -> ManagedChild? {
        guard let currentIndex = index(ofChild: viewController) else { return nil }
        return child(at: managedChildren.index(after: currentIndex))
    }
    
    func child(preceding viewController: UIViewController) -> ManagedChild? {
        guard let currentIndex = index(ofChild: viewController) else { return nil }
        return child(at: managedChildren.index(before: currentIndex))
    }
    
    func indexOfChild(following viewController: UIViewController) -> Int? {
        guard let currentIndex = index(ofChild: viewController) else { return nil }
        let nextIndex = managedChildren.index(after: currentIndex)
        
        return nextIndex < managedChildren.endIndex ? nextIndex : nil
    }
    
    func indexOfChild(preceding viewController: UIViewController) -> Int? {
        guard let currentIndex = index(ofChild: viewController) else { return nil }
        let previousIndex = managedChildren.index(before: currentIndex)
        
        return previousIndex >= managedChildren.startIndex ? previousIndex : nil
    }
    
    // MARK: Removing a ManagedChild
    func removeChild(_ child: ManagedChild) {
        let removed = managedChildren.firstIndex { $0.identifier == child.identifier }.flatMap { managedChildren.remove(at: $0) }
        removed?.viewController.removeFromParent()
    }
    
    func removeChildren(where predicate: (ManagedChild) -> Bool) {
        managedChildren.filter(predicate).forEach(removeChild)
    }
}
