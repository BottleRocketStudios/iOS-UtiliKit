//
//  UtiliKitTests.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import UtiliKit

class OpenSourceUtilitiesTests: XCTestCase {
    var view: UIView!
    var superview: UIView!
    
    override func setUp() {
        super.setUp()
        
        superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view = UIView(frame: .zero)
    }
    
    override func tearDown() {
        view = nil
        superview = nil
        
        super.tearDown()
    }
    
    //MARK: - Subview Tests
    @available(iOS 11, *)
    func test_AddSubview_TranslatesAutoresizingMaskIntoConstraintsIsFalse() {
        superview.addSubview(view, constrainedToSuperview: true, usingSafeArea: true)
        
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
    }
    
    @available(iOS 11, *)
    func test_AddSubview_ConstraintsAdded() {
        superview.addSubview(view, constrainedToSuperview: true, usingSafeArea: false)
        
        XCTAssertEqual(superview.constraints.count, 4)
    }
    
    @available(iOS 11, *)
    func test_ConstrainSubview_ConstraintsAdded() {
        superview.addSubview(view)
        view.centerViewInSuperview(usingSafeArea: true)
        
        XCTAssertEqual(superview.constraints.count, 2)
    }
}
