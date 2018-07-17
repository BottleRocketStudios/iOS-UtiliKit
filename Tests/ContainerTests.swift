//
//  ContainerTests.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 7/16/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import UIKit
@testable import UtiliKit

class ContainerTests: XCTestCase {
    
    func test_Container_indexOfChild() {
        let viewController = UIViewController()
        let children = [Child(title: "title", viewController: viewController),
                        Child(title: "title2", viewController: UIViewController())]
        
        let container = ContainerViewController(managedChildren: children)
        XCTAssertNil(container.index(ofChild: UIViewController()))
        XCTAssertEqual(container.index(ofChild: viewController), 0)
    }
    
    func test_Container_indexOfChildFollowing() {
        let viewController = UIViewController()
        let children = [Child(title: "title", viewController: viewController),
                        Child(title: "title2", viewController: UIViewController())]
        
        let container = ContainerViewController(managedChildren: children)
        XCTAssertEqual(container.indexOfChild(following: viewController), 1)
        XCTAssertNil(container.indexOfChild(following: UIViewController()))
    }
    
    func test_Container_childAtIndex() {
        let children = [Child(title: "title", viewController: UIViewController()),
                        Child(title: "title2", viewController: UIViewController()),
                        Child(title: "title3", viewController: UIViewController()),
                        Child(title: "title4", viewController: UIViewController())]
        
        let container = ContainerViewController(managedChildren: children)
        
        for idx in 0..<children.count {
            XCTAssertNotNil(container.child(at: idx))
        }
        
        XCTAssertNil(container.child(at: children.count))
    }
}
