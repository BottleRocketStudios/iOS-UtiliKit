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

    func test_clamping_lessThanMin() {
        XCTAssertEqual(-5.clamped(min: 0, max: 10), 0)
    }

    func test_clamping_equalToMin() {
        XCTAssertEqual(0.clamped(min: 0, max: 10), 0)
    }

    func test_clamping_inMinMax() {
        XCTAssertEqual(5.clamped(min: 0, max: 10), 5)
    }

    func test_clamping_equalToMax() {
        XCTAssertEqual(10.clamped(min: 0, max: 10), 10)
    }

    func test_clamping_greaterThanMax() {
        XCTAssertEqual(15.clamped(min: 0, max: 10), 10)
    }

    func test_clamping_lessThanMinRange() {
        XCTAssertEqual(-5.clamped(in: 0...10), 0)
    }

    func test_clamping_equalToMinRange() {
        XCTAssertEqual(0.clamped(in: 0...10), 0)
    }

    func test_clamping_inRange() {
        XCTAssertEqual(5.clamped(in: 0...10), 5)
    }

    func test_clamping_equalToMaxRange() {
        XCTAssertEqual(10.clamped(in: 0...10), 10)
    }

    func test_clamping_greaterThanMaxRange() {
        XCTAssertEqual(15.clamped(in: 0...10), 10)
    }
}
