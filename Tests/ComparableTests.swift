//
//  ComparableTests.swift
//  UtiliKit iOS Tests
//
//  Created by Nathan Chiu on 5/19/22.
//  Copyright © 2022 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import UtiliKit

class ComparableTests: XCTestCase {

    let minValue = 0
    let maxValue = 10
    let middleValue = 5
    let lessThanValue = -5
    let greaterThanValue = 15

    func test_clamping_lessThanMin() {
        XCTAssertEqual(lessThanValue.clamped(min: minValue, max: maxValue), minValue)
    }

    func test_clamping_equalToMin() {
        XCTAssertEqual(minValue.clamped(min: minValue, max: maxValue), minValue)
    }

    func test_clamping_inMinMax() {
        XCTAssertEqual(middleValue.clamped(min: minValue, max: maxValue), middleValue)
    }

    func test_clamping_equalToMax() {
        XCTAssertEqual(maxValue.clamped(min: minValue, max: maxValue), maxValue)
    }

    func test_clamping_greaterThanMax() {
        XCTAssertEqual(greaterThanValue.clamped(min: minValue, max: maxValue), maxValue)
    }

    func test_clamping_lessThanMinRange() {
        XCTAssertEqual(lessThanValue.clamped(in: minValue...maxValue), minValue)
    }

    func test_clamping_equalToMinRange() {
        XCTAssertEqual(minValue.clamped(in: minValue...maxValue), minValue)
    }

    func test_clamping_inRange() {
        XCTAssertEqual(middleValue.clamped(in: minValue...maxValue), middleValue)
    }

    func test_clamping_equalToMaxRange() {
        XCTAssertEqual(maxValue.clamped(in: minValue...maxValue), maxValue)
    }

    func test_clamping_greaterThanMaxRange() {
        XCTAssertEqual(greaterThanValue.clamped(in: minValue...maxValue), maxValue)
    }
}
