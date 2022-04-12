//
//  MappingCoordinate.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/25/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// Describes a point on Earth in degrees latitude and longitude.
public struct MappingCoordinate {

    /// Specifies the distance from the equator. Valid values are `-90...90`. `0` is the equator, `>0` is the northern hemisphere, and `<0` is the southern hemisphere.
    public let latitude: Float

    /// Specifies the distance from the Prime Meridian. Valid values are `-180...180`. `0` is the Prime Meridian, `>0` is the eastern hemisphere, and `<0` is the western hemisphere.
    public let longitude: Float

    /// Comma separated string value in the format "`latitude`,`longitude`"
    public var stringValue: String { "\(latitude),\(longitude)" }

    public init(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
