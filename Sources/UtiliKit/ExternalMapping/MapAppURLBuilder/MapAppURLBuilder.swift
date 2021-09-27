//
//  MapAppURLBuilder.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/25/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public protocol MapAppURLBuilder {
    typealias Coordinate = MappingCoordinate

    /// Basic URL to link to the app without any parameters.
    static var launchAppURL: URL { get }

    /// The expected range of zoom values supported by the app.
    static var zoomRange: ClosedRange<Float> { get }

    /// Display a specific location on the map.
    /// - Parameters:
    ///   - coordinate: The point on the map to display.
    ///   - zoomPercent: A percent value in the range of `0...100` to specify how far to zoom in on the map.
    ///   - style: Style of map to display.
    /// - Returns: A URL to the map app.
    static func displayLocation(at coordinate: Coordinate, zoomPercent: Float?, style: MapStyle?) -> URL

    /// Perform a search on the map.
    /// - Parameters:
    ///   - query: The term or address to search for.
    ///   - coordinate: A location to perform the search at.
    ///   - style: Style of map to display.
    /// - Returns: A URL to the map app
    static func search(for query: String, near coordinate: Coordinate?, style: MapStyle?) -> URL

    /// Get directions on the map.
    /// - Parameters:
    ///   - toAddress: The location to get get directions to.
    ///   - fromAddress: The location to start from.
    ///   - navigationMode: The method of transportation to get directions for.
    ///   - style: Style of map to display.
    /// - Returns: A URL to the map app.
    static func navigate(to toAddress: String, from fromAddress: String?, via navigationMode: NavigationMode?, style: MapStyle?) -> URL
}

extension MapAppURLBuilder {

    /// A helper function to convert a percentage value to a zoom value based on the builder's `zoomRange`
    /// - Parameter percent: `0...100` percent value 
    /// - Returns: The value at the specified `percent` in the `zoomRange`
    static func zoomValue(fromPercent percent: Float?) -> Float? {
        guard let percent = percent else { return nil }
        return (percent / 100 * (zoomRange.upperBound - zoomRange.lowerBound)) + zoomRange.lowerBound
    }
}
