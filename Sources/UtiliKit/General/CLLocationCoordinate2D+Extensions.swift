//
//  CLLocationCoordinate2D+Extensions.swift
//  UtiliKit-iOS
//
//  Created by Andrew Winn on 8/24/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import CoreLocation

public extension CLLocationCoordinate2D {

    /// Checks if a coordinate is valid. Attempting to use an invalid coordinate (e.g. by setting a map region to center on it) will crash the app.
    ///
    /// A coordinate is considered **invalid** if it meets at least one of the following criteria:
    /// - Its latitude is greater than 90 degrees or less than -90 degrees.
    /// - Its longitude is greater than 180 degrees or less than -180 degrees.
    ///
    /// An invalid coordinate can be generated from:
    /// - Invalid data from an API
    /// - `mkMapView.userLocation.coordinate` is not an optional property and will provide an invalid coordinate when the user is not sharing their location.
    /// - `locationManager.location.coordinate` is an optional property but may still provide an invalid coordinate (e.g. when the user has revoked location permissions while the app is running after previously granting)
    var isValid: Bool {
        if CLLocationCoordinate2DIsValid(self) {
            return true
        }
        debugPrint("================================================")
        debugPrint("Invalid CLLocationCoordinate2D Detected: \(self)")
        debugPrint("================================================")
        return false
    }
}
