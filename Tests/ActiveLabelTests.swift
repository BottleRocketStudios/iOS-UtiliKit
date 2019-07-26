//
//  ActiveLabelTests.swift
//  UtiliKit-iOSTests
//
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import XCTest
import UIKit
import SnapshotTesting
@testable import UtiliKit

class ActiveLabelTests: XCTestCase {
    private let tempText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    
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
        XCTAssertEqual(label.state, .loading)
        XCTAssertEqual(label.subviews.count, Int(label.estimatedNumberOfLines))

        label.text = tempText
        XCTAssertEqual(label.state, .text(tempText))
        XCTAssertEqual(label.subviews.count, 0)
    }
    
    func testMultiLine() {
        let label: ActiveLabel = ActiveLabel()
        label.numberOfLines = 0
        label.estimatedNumberOfLines = 3
        label.finalLineTrailingInset = 100
        
        XCTAssertEqual(label.estimatedNumberOfLines, 3)
        XCTAssertEqual(label.finalLineTrailingInset, 100)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
        XCTAssertEqual(label.state, .loading)
        XCTAssertEqual(label.subviews.count, Int(label.estimatedNumberOfLines))

        label.text = tempText
        XCTAssertEqual(label.state, .text(tempText))
        XCTAssertEqual(label.subviews.count, 0)

        label.finalLineTrailingInset = 0
        label.finalLineLength = 100
        
        label.text = nil
        XCTAssertEqual(label.state, .loading)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 100)
        XCTAssertEqual(label.subviews.count, Int(label.estimatedNumberOfLines))
    }
    
    func testManualHiding() {
        let label: ActiveLabel = ActiveLabel()

        label.isHidden = true
        XCTAssertEqual(label.subviews.first?.isHidden, true)

        label.isHidden = false
        XCTAssertEqual(label.subviews.first?.isHidden, false)
    }
    
    func testConvenienceInitializerDefault() {
        let label = ActiveLabel(frame: .zero, configuration: ActiveLabel.Configuration.default)

        XCTAssertEqual(label.estimatedNumberOfLines, 1)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, ActiveLabel.loadingGray)
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
    }
    
    func testConvenvienceInitializerModified() {
        var configuration = ActiveLabel.Configuration.default
        configuration.estimatedNumberOfLines = 2
        configuration.loadingView.color = .red
        let label = ActiveLabel(frame: .zero, configuration: configuration)

        XCTAssertEqual(label.estimatedNumberOfLines, 2)
        XCTAssertEqual(label.finalLineTrailingInset, 0)
        XCTAssertEqual(label.finalLineLength, 0)
        XCTAssertEqual(label.loadingViewColor, .red)
        XCTAssertEqual(label.loadingLineHeight, 8)
        XCTAssertEqual(label.loadingLineVerticalSpacing, 14)
        XCTAssertEqual(label.loadingAnimationDuration, 2.4)
        XCTAssertEqual(label.loadingAnimationDelay, 0.4)
    }
    
// MARK: - Snapshot Tests
    func testDefaultsSnapshot() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let label = ActiveLabel()
        addLabel(label, to: viewController)

        label.configureForSnapshotTest()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    func testSingleLineSnapshot() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let label = ActiveLabel()
        addLabel(label, to: viewController)
        
        label.configureForSnapshotTest()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        label.text = tempText
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    func testMultiLineSnapshot() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let label = ActiveLabel()
        addLabel(label, to: viewController)
        
        label.numberOfLines = 0
        label.estimatedNumberOfLines = 3
        label.finalLineTrailingInset = 100
        label.configureForSnapshotTest()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        label.text = tempText
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        label.finalLineTrailingInset = 0
        label.finalLineLength = 100
        label.text = nil
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        label.text = tempText
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    func testHidingSnapshot() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let label = ActiveLabel()
        addLabel(label, to: viewController)
        
        label.configureForSnapshotTest()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        label.isHidden = true
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        label.isHidden = false
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    func testConvenienceInitializerSnapshot() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let label = ActiveLabel(frame: .zero, configuration: ActiveLabel.Configuration.default)
        addLabel(label, to: viewController)
        
        label.configureForSnapshotTest()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    func testConvenienceInitializerModifiedSnapshot() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        var configuration = ActiveLabel.Configuration.default
        configuration.estimatedNumberOfLines = 2
        configuration.loadingView.color = .red
        configuration.finalLineTrailingInset = 100
        let label = ActiveLabel(frame: .zero, configuration: configuration)
        addLabel(label, to: viewController)
        
        label.configureForSnapshotTest()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    func testMultipleLabelsSnapshot() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        let firstLabel = ActiveLabel()
        addLabel(firstLabel, to: viewController)
        firstLabel.configureForSnapshotTest()
        
        let secondLabel = ActiveLabel()
        secondLabel.numberOfLines = 0
        secondLabel.estimatedNumberOfLines = 3
        secondLabel.finalLineTrailingInset = 100
        addLabel(secondLabel, to: viewController, below: firstLabel)
        secondLabel.configureForSnapshotTest()
        
        var configuration = ActiveLabel.Configuration.default
        configuration.estimatedNumberOfLines = 2
        configuration.loadingView.color = .red
        configuration.finalLineTrailingInset = 100
        let thirdLabel = ActiveLabel(frame: .zero, configuration: configuration)
        thirdLabel.numberOfLines = 2
        addLabel(thirdLabel, to: viewController, below: secondLabel)
        thirdLabel.configureForSnapshotTest()
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        firstLabel.text = tempText
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        secondLabel.text = tempText
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        
        thirdLabel.text = tempText
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    private func addLabel(_ label: ActiveLabel, to viewController: UIViewController, below aboveView: UIView? = nil) {
        label.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(label)
        
        if let aboveView = aboveView {
            label.topAnchor.constraint(equalTo: aboveView.bottomAnchor, constant: 20).isActive = true
        } else {
            label.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 20).isActive = true
        }
        
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
                                     label.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20)])
    }
}
