//
//  ClosedRangeTests.swift
//  UtiliKit-iOSTests
//
//  Created by Nathan Chiu on 9/25/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import UtiliKit

class ClosedRangeTests: XCTestCase {

    let testRange = 0...10

    func test_clampingAValueInRange() {
        let clampedValue = testRange.clamp(value: 5)
        XCTAssertEqual(clampedValue, 5)
    }

    func test_clampingAValueBelowRange() {
        let clampedValue = testRange.clamp(value: -5)
        XCTAssertEqual(clampedValue, 0)
    }

    func test_clampingAValueAboveRange() {
        let clampedValue = testRange.clamp(value: 15)
        XCTAssertEqual(clampedValue, 10)
    }

    func test_clampingUpperBound() {
        let clampedValue = testRange.clamp(value: testRange.upperBound)
        XCTAssertEqual(clampedValue, 10)
    }

    func test_clampingLowerBound() {
        let clampedValue = testRange.clamp(value: testRange.lowerBound)
        XCTAssertEqual(clampedValue, 0)
    }
}
