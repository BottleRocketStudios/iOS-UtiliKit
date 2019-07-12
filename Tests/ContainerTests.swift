//
//  ContainerTests.swift
//  UtiliKit-iOS
//
//  Created by Will McGinty on 7/16/18.
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import XCTest
import UIKit
@testable import UtiliKit

class ContainerTests: XCTestCase {
    
    func test_Container_indexOfChild() {
        let viewController = UIViewController()
        let children = [Child(identifier: "title", viewController: viewController),
                        Child(identifier: "title2", viewController: UIViewController())]
        
        let container = ContainerViewController(managedChildren: children)
        XCTAssertNil(container.index(ofChild: UIViewController()))
        XCTAssertEqual(container.index(ofChild: viewController), 0)
    }
    
    func test_Container_indexOfChildFollowing() {
        let viewController = UIViewController()
        let viewController2 = UIViewController()
        let children = [Child(identifier: "title", viewController: viewController),
                        Child(identifier: "title2", viewController: viewController2)]
        
        let container = ContainerViewController(managedChildren: children)
        XCTAssertEqual(container.indexOfChild(following: viewController), 1)
        XCTAssertNil(container.indexOfChild(following: UIViewController()))
        XCTAssertNil(container.indexOfChild(following: viewController2))
    }
    
    func test_Container_indexOfChildPreceding() {
        let viewController = UIViewController()
        let viewController2 = UIViewController()
        let children = [Child(identifier: "title", viewController: viewController),
                        Child(identifier: "title2", viewController: viewController2)]
        
        let container = ContainerViewController(managedChildren: children)
        XCTAssertEqual(container.indexOfChild(preceding: viewController2), 0)
        XCTAssertNil(container.indexOfChild(preceding: UIViewController()))
        XCTAssertNil(container.indexOfChild(preceding: viewController))
    }
    
    func test_Container_childAtIndex() {
        let children = [Child(identifier: "title", viewController: UIViewController()),
                        Child(identifier: "title2", viewController: UIViewController()),
                        Child(identifier: "title3", viewController: UIViewController()),
                        Child(identifier: "title4", viewController: UIViewController())]
        
        let container = ContainerViewController(managedChildren: children)
        
        for idx in 0..<children.count {
            XCTAssertNotNil(container.child(at: idx))
        }
        
        XCTAssertNil(container.child(at: children.count))
    }
}
