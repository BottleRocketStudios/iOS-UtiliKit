//
//  CGSizeTests.swift
//  UtiliKit iOS
//
//  Created by Nathan Chiu on 5/19/22.
//  Copyright © 2022 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import UtiliKit

class CGSizeTests: XCTestCase {
    
    func test_one_correctSize() {
        XCTAssertEqual(CGSize.one.width, 1)
        XCTAssertEqual(CGSize.one.height, 1)
    }
}
