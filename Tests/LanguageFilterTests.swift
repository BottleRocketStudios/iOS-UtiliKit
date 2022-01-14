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

    func test_yesOffensiveLanguageDoesReturnTrue() {
        // arrange
        let offensive = "ass"
        // act
        let containsOffensiveLanguage = offensive.containsOffensiveLanguage
        // assert
        XCTAssert(containsOffensiveLanguage, "Should not trigger the offensive language filter")
    }

    func test_replacesWithCorrectLength() {
        //arrange
        let offensive = "bite my shiny metal ass"
        // act
        let replaced = offensive.removingOffensiveLanguage
        let asterisks = replaced.filter { $0 == "*" }
        // assert
        XCTAssert(asterisks.count == 3, "Incorrect replacement length in \(replaced)")
    }

    func test_doesNotReplaceInoffensive() {
        // arrange
        let unoffensive = "my hovercraft is full of eels"
        // act
        let replaced = unoffensive.removingOffensiveLanguage
        // assert
        XCTAssert(!replaced.contains("*"), "Incorrect replacement in \(replaced)")
    }

    func test_replacesWithAlternateCharacter() {
        //arrange
        let offensive = "bite my shiny metal ass"
        // act
        let replaced = offensive.replacingOffensiveWords(with: "•")
        let asterisks = replaced.filter { $0 == "•" }
        // assert
        XCTAssert(asterisks.count == 3, "Incorrect replacement length in \(replaced)")
    }

}
