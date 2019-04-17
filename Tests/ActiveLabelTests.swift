//
//  ActiveLabelTests.swift
//  UtiliKit-iOSTests
//
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import UIKit
@testable import UtiliKit

class ActiveLabelTests: XCTestCase {
    
    func testLabelDefaults() {
        let label: ActiveLabel = ActiveLabel()
        
        XCTAssertEqual(label.estimatedNumberOfLines, 1)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
    }
    
    func testSingleLine() {
        let label: ActiveLabel = ActiveLabel()
        
        XCTAssertEqual(label.estimatedNumberOfLines, 1)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
        
        XCTAssertEqual(label.isLoading, true)
        XCTAssertEqual(label.subviews.count, Int(label.estimatedNumberOfLines))
        
        label.text = "Test"
        XCTAssertEqual(label.isLoading, false)
        XCTAssertEqual(label.subviews.count, 0)
    }
    
    func testMultiLine() {
        let label: ActiveLabel = ActiveLabel()
        label.estimatedNumberOfLines = 3
        label.finalLineTrailingInset = 100
        label.configurationChanged()
        
        XCTAssertEqual(label.estimatedNumberOfLines, 3)
        XCTAssertEqual(label.finalLineTrailingInset, 100)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
        
        XCTAssertEqual(label.isLoading, true)
        XCTAssertEqual(label.subviews.count, Int(label.estimatedNumberOfLines))
        
        label.text = "Test"
        XCTAssertEqual(label.isLoading, false)
        XCTAssertEqual(label.subviews.count, 0)
        
        label.finalLineTrailingInset = 0
        label.finalLineLength = 100
        label.configurationChanged()
        
        label.text = nil
        XCTAssertEqual(label.isLoading, true)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 100)
        XCTAssertEqual(label.subviews.count, Int(label.estimatedNumberOfLines))
    }
    
    func testManualHiding() {
        let viewController = UIViewController()
        viewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        
        let label: ActiveLabel = ActiveLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
                                     label.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 20)])
        
        label.isHidden = true
        XCTAssertEqual(label.subviews.first?.isHidden, true)
        
        label.isHidden = false
        XCTAssertEqual(label.subviews.first?.isHidden, false)
    }
    
    func testConvenienceInitializerDefault() {
        let label = ActiveLabel(frame: .zero, configuration: ActiveLabel.ActiveLabelConfiguration.default)
        
        XCTAssertEqual(label.estimatedNumberOfLines, 1)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
    }
    
    func testConvenvienceInitializerModified() {
        var configuration = ActiveLabel.ActiveLabelConfiguration.default
        configuration.estimatedNumberOfLines = 2
        let label = ActiveLabel(frame: CGRect(x: 0, y: 0, width: 335, height: 21), configuration: configuration)
        
        XCTAssertEqual(label.estimatedNumberOfLines, 2)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
    }
}
