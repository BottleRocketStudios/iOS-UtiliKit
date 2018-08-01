//
//  ContainerViewController+ManagedChildren.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 8/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public extension ContainerViewController {
    
    //MARK: Finding a Child
    func index(ofChild controller: UIViewController) -> Int? {
        return managedChildren.index(where: { $0.viewController === controller })
    }
    
    func indexOfChild(following viewController: UIViewController) -> Int? {
        guard let currentIndex = index(ofChild: viewController) else { return nil }
        let nextIndex = managedChildren.index(after: currentIndex)
        
        return nextIndex < managedChildren.endIndex ? nextIndex : nil
    }
    
    // MARK: Removing a Child
    func removeChild(_ child: Child) {
        if let index = managedChildren.index(of: child) {
            let removed = managedChildren.remove(at: index)
            removed.viewController.removeFromParentViewController()
        }
    }
    
    func removeChildren(where predicate: (Child) -> Bool) {
        managedChildren.filter(predicate).forEach(removeChild)
    }
}
