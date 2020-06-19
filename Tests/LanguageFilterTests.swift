//
//  LanguageFilterTests.swift
//  UtiliKit-iOSTests
//
//  Created by Russell Mirabelli on 6/19/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import UtiliKit
import XCTest

class LanguageFilterTests: XCTestCase {

    func test_noOffensiveLanguageDoesNotReturnTrue() {
        // arrange
        let unoffensive = "angel"
        // act
        let containsOffensiveLanguage = unoffensive.containsOffensiveLanguage
        // assert
        XCTAssert(!containsOffensiveLanguage, "Should not trigger the offensive language filter")
    }

}
