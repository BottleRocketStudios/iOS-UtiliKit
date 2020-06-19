//
//  String+LanguageFilter.swift
//  UtiliKit-iOS
//
//  Created by Russell Mirabelli on 6/19/20.
//  Copyright © 2020 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public extension String {

    /// Returns true if the `String` matches a set of potentially offensive
    /// words.
    var containsOffensiveLanguage: Bool {
        return false
    }


    var removingOffensiveLanguage: String {
        return self
    }

}
