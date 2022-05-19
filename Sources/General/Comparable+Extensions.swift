//
//  Comparable+Extensions.swift
//  UtiliKit iOS
//
//  Created by Nathan Chiu on 5/19/22.
//  Copyright © 2022 Bottle Rocket Studios. All rights reserved.
//

import Foundation

extension Comparable {

    /// Keeps the value within the specified `min` and `max` values
    /// - Parameters:
    ///   - minValue: The minimum value to return
    ///   - maxValue: The maximum value to return
    /// - Returns: The `minValue` if less than `minValue`, else `maxValue` if greater than `maxValue`, else the value itself
    func clamped(min minValue: Self, max maxValue: Self) -> Self {
        min(max(minValue, self), maxValue)
    }

    /// Keeps the value within the specified `range` of values
    /// - Parameter range: The range of values to return
    /// - Returns: The `range.lowerBound` if less than the range, else `range.upperBound` if greater than the range, else the value itself
    func clamped(in range: Range<Self>) -> Self {
        clamped(min: range.lowerBound, max: range.upperBound)
    }
}
