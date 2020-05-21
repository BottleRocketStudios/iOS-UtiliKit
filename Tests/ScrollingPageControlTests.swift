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
    
    func testDefaults() {
        let pageControl = ScrollingPageControl()
        
        XCTAssertEqual(pageControl.accessibilityLabel, "")
        XCTAssertEqual(pageControl.accessibilityTraits, "")
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
}
