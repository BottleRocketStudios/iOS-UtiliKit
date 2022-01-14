//
//  URL+Extensions.swift
//  UtiliKit-iOS
//
//  Created by William McGinty on 7/22/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    
    /// Creates a `URL` from a string literal object. This initializer will `fatalError` if given an invalid URL string. This initializer is intended for pre-defined strings, and should be used with extreme caution.
    ///
    /// - Parameter value: The literal string to which a `URL` object should be initialized, or crash if invalid.
    public init(stringLiteral value: StaticString) {
        guard let url = URL(string: value.description) else {
            fatalError("Invalid URL string: \(value)")
        }
        
        self = url
    }
}
