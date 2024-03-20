//
//  String+Extensions.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 1/19/22.
//  Copyright © 2022 Bottle Rocket Studios. All rights reserved.
//

import Foundation

extension String {

    /// `nil` if the string is empty, else the value of the string
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    /// Encode the string for use as a URL query parameter
    var urlQueryEncoded: String? {
        replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.nilIfEmpty
    }
}
