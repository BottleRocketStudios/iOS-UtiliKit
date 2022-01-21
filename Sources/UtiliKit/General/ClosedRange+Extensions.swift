//
//  ClosedRange+Extensions.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/25/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public extension ClosedRange {

    /// Clamps a value to a `ClosedRange`
    /// - Parameter value: The value to clamp.
    /// - Returns: `value` if it is in range, else `upperBound` if it is above the range, else `lowerBound` if it is below the range.
    func clamp(value: Bound) -> Bound {
        value > upperBound ? upperBound : (value < lowerBound ? lowerBound : value)
    }
}
