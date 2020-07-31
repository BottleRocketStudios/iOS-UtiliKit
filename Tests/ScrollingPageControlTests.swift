//
//  ScrollingPageControlTests.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 5/21/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import XCTest
import UIKit
import SnapshotTesting
@testable import UtiliKit

class ScrollingPageControlTests: XCTestCase {
    
    func testDefaultsWithNoPages() {
        let pageControl = ScrollingPageControl()
        
        XCTAssertEqual(pageControl.accessibilityLabel, "no pages")
        XCTAssertEqual(pageControl.accessibilityTraits, [.adjustable, .updatesFrequently])
        XCTAssertEqual(pageControl.accessibilityValue, "")
        XCTAssertEqual(pageControl.currentPage, 0)
        XCTAssertEqual(pageControl.currentPageIndicatorTintColor, UIColor.systemBlue)
        XCTAssertEqual(pageControl.dotSize, CGSize(width: 7.0, height: 7.0))
        XCTAssertEqual(pageControl.dotSpacing, 9.0)
        XCTAssertEqual(pageControl.hidesForSinglePage, false)
        XCTAssertEqual(pageControl.intrinsicContentSize, CGSize.zero)
        XCTAssertEqual(pageControl.isAccessibilityElement, true)
        XCTAssertEqual(pageControl.mainDotCount, 3)
        XCTAssertEqual(pageControl.marginDotCount, 2)
        XCTAssertEqual(pageControl.maxVisibleDots, 7)
        XCTAssertEqual(pageControl.minimumDotScale, 0.4)
        XCTAssertEqual(pageControl.numberOfPages, 0)
        XCTAssertEqual(pageControl.pageIndicatorTintColor, UIColor.systemGray)
    }
    
    func testDefaultsWithFivePages() {
        let pageControl = ScrollingPageControl()
        pageControl.numberOfPages = 5
        
        XCTAssertEqual(pageControl.accessibilityLabel, "page 1 of 5")
        XCTAssertEqual(pageControl.accessibilityTraits, [.adjustable, .updatesFrequently])
        XCTAssertEqual(pageControl.accessibilityValue, "1")
        XCTAssertEqual(pageControl.currentPage, 0)
        XCTAssertEqual(pageControl.currentPageIndicatorTintColor, UIColor.systemBlue)
        XCTAssertEqual(pageControl.dotSize, CGSize(width: 7.0, height: 7.0))
        XCTAssertEqual(pageControl.dotSpacing, 9.0)
        XCTAssertEqual(pageControl.hidesForSinglePage, false)
        XCTAssertEqual(pageControl.intrinsicContentSize, CGSize(width: 71.0, height: 37.0))
        XCTAssertEqual(pageControl.isAccessibilityElement, true)
        XCTAssertEqual(pageControl.mainDotCount, 3)
        XCTAssertEqual(pageControl.marginDotCount, 2)
        XCTAssertEqual(pageControl.maxVisibleDots, 7)
        XCTAssertEqual(pageControl.minimumDotScale, 0.4)
        XCTAssertEqual(pageControl.numberOfPages, 5)
        XCTAssertEqual(pageControl.pageIndicatorTintColor, UIColor.systemGray)
        
        assertSnapshot(matching: setupForSnapshot(pageControl: pageControl), as: .image(on: .iPhoneX))
    }
    
    func testDefaultsWithTenPages() {
        let pageControl = ScrollingPageControl()
        pageControl.numberOfPages = 10
        
        XCTAssertEqual(pageControl.accessibilityLabel, "page 1 of 10")
        XCTAssertEqual(pageControl.accessibilityTraits, [.adjustable, .updatesFrequently])
        XCTAssertEqual(pageControl.accessibilityValue, "1")
        XCTAssertEqual(pageControl.currentPage, 0)
        XCTAssertEqual(pageControl.currentPageIndicatorTintColor, UIColor.systemBlue)
        XCTAssertEqual(pageControl.dotSize, CGSize(width: 7.0, height: 7.0))
        XCTAssertEqual(pageControl.dotSpacing, 9.0)
        XCTAssertEqual(pageControl.hidesForSinglePage, false)
        XCTAssertEqual(pageControl.intrinsicContentSize, CGSize(width: 103.0, height: 37.0))
        XCTAssertEqual(pageControl.isAccessibilityElement, true)
        XCTAssertEqual(pageControl.mainDotCount, 3)
        XCTAssertEqual(pageControl.marginDotCount, 2)
        XCTAssertEqual(pageControl.maxVisibleDots, 7)
        XCTAssertEqual(pageControl.minimumDotScale, 0.4)
        XCTAssertEqual(pageControl.numberOfPages, 10)
        XCTAssertEqual(pageControl.pageIndicatorTintColor, UIColor.systemGray)
        
        assertSnapshot(matching: setupForSnapshot(pageControl: pageControl), as: .image(on: .iPhoneX))
    }
    
    func testColorChange() {
        let pageControl = ScrollingPageControl()
        let vc = setupForSnapshot(pageControl: pageControl)
        
        pageControl.numberOfPages = 10
        pageControl.pageIndicatorTintColor = .systemRed
        pageControl.currentPageIndicatorTintColor = .systemGreen
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
        
        pageControl.backgroundColor = .systemYellow
        pageControl.tintColor = .systemPurple
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testCurrentPageChange() {
        let pageControls = [ScrollingPageControl(),
                            makeWideDotPageControl(),
                            makeTallDotPageControl()]
        let snapshotVC = setupForSnapshot(pageControls: pageControls)
        
        pageControls.forEach {
            $0.numberOfPages = 10
        }
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
        
        pageControls.forEach {
            $0.currentPage = 5
        }
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
        
        pageControls.forEach {
            $0.currentPage = 9
        }
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
        
        pageControls.forEach {
            $0.currentPage = 4
        }
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
    }
    
    func testCustomPageDots() {
        let pageControl = ScrollingPageControl()
        let snapshotVC = setupForSnapshot(pageControl: pageControl)
        pageControl.customPageDotAtIndex = { index in
            let label = TintableLabel()
            switch index % 4 {
            case 0: label.text = "♠︎"
            case 1: label.text = "♥︎"
            case 2: label.text = "♣︎"
            case 3: label.text = "♦︎"
            default: return nil
            }
            return label
        }
        pageControl.dotSize = CGSize(width: max(pageControl.customPageDotAtIndex!(0)!.intrinsicContentSize.width,
                                                pageControl.customPageDotAtIndex!(1)!.intrinsicContentSize.width,
                                                pageControl.customPageDotAtIndex!(2)!.intrinsicContentSize.width,
                                                pageControl.customPageDotAtIndex!(3)!.intrinsicContentSize.width),
                                     height: pageControl.customPageDotAtIndex!(0)!.intrinsicContentSize.height)
        pageControl.numberOfPages = 30
        pageControl.marginDotCount = 3
        pageControl.mainDotCount = 5
        pageControl.currentPageIndicatorTintColor = .systemRed
        pageControl.pageIndicatorTintColor = .systemTeal
        
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
        pageControl.currentPage = 10
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
        pageControl.currentPage = 29
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
        pageControl.currentPage = 5
        assertSnapshot(matching: snapshotVC, as: .image(on: .iPhoneX))
    }
    
    private func setupForSnapshot(pageControl: ScrollingPageControl) -> UIViewController {
        return setupForSnapshot(pageControls: [pageControl])
    }
    
    private func setupForSnapshot(pageControls: [ScrollingPageControl]) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        pageControls.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let stack = UIStackView(arrangedSubviews: pageControls)
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(stack)
        stack.centerViewInSuperview()
        return vc
    }
    
    private func makeWideDotPageControl() -> ScrollingPageControl {
        let pageControl = ScrollingPageControl()
        pageControl.dotSize = CGSize(width: 14.0, height: 7.0)
        pageControl.dotSpacing = 6.0
        return pageControl
    }
    
    private func makeTallDotPageControl() -> ScrollingPageControl {
        let pageControl = ScrollingPageControl()
        pageControl.dotSize = CGSize(width: 7.0, height: 14.0)
        pageControl.dotSpacing = 12.0
        return pageControl
    }
}

private class TintableLabel: UILabel {
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        textColor = tintColor
    }
}
