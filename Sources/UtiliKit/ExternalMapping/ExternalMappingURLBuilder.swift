//
//  ExternalMappingURLBuilder.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/24/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public struct ExternalMappingURLBuilder {

    // MARK: Properties

    private let apps: [MapApp]

    // MARK: Initializers

    /// Create an instance with the external mapping apps
    /// - Parameter apps: The apps the builder will build links to. Optional, defaults to all supported apps.
    public init(apps: [MapApp] = MapApp.allCases) {
        self.apps = apps
    }

    // MARK: Public

    /// Creates links to display a specific location on the map.
    /// - Parameters:
    ///   - coordinate: The location on the map to display.
    ///   - zoomPercent: The zoom level specified on a `0.0...1.0` scale. `1.0` represents fully zoomed in on the location. Optional, defaults to `nil`.
    ///   - style: The map style to display. Optional, defaults to `nil`.
    /// - Returns: URLs to display the location in each of the supported map apps.
    public func displayLocation(at coordinate: MappingCoordinate, zoomPercent: Float?, style: MapStyle?) -> [MapApp: URL] {
        apps.reduce(into: [:]) { partialResult, app in
            partialResult[app] = app.interface.displayLocation(at: coordinate, zoomPercent: zoomPercent, style: style)
        }
    }

    /// Creates links to search the map.
    /// - Parameters:
    ///   - query: What to search for; can be a term like `"pizza"`  or a partial address like `"14841 Dallas Parkway"` or `"Addison, TX"`.
    ///   - coordinate: Specify a location to perform the search at. Optional, defaults to `nil`.
    ///   - style: The map style to display. Optional, defaults to `nil`.
    /// - Returns: URLs to search for the `query` in each of the supported map apps.
    public func search(for query: String, near coordinate: MappingCoordinate?, style: MapStyle?) -> [MapApp: URL] {
        apps.reduce(into: [:]) { partialResult, app in
            partialResult[app] = app.interface.search(for: query, near: coordinate, style: style)
        }
    }

    /// Creates links to get directions on the map.
    /// - Parameters:
    ///   - toAddress: The destination location.
    ///   - fromAddress: The starting location. Optional, defaults to `nil`.
    ///   - navigationMode: The method of travel to get directions for.
    ///   - style: The map style to display. Optional, defaults to `nil`.
    /// - Returns: URLs to get directions to the `toAddress` in each of the supported map apps.
    public func navigate(to toAddress: String, from fromAddress: String?, via navigationMode: NavigationMode?, style: MapStyle?) -> [MapApp: URL] {
        apps.reduce(into: [:]) { partialResult, app in
            partialResult[app] = app.interface.navigate(to: toAddress, from: fromAddress, via: navigationMode, style: style)
        }
    }
}

// MARK: - ExternalMappingURLBuilder.MapApp

extension ExternalMappingURLBuilder {
    public enum MapApp: CaseIterable {
        case apple
        case google
        case waze

        public var title: String {
            switch self {
            case .apple:
                return "Apple Maps"
            case .google:
                return "Google Maps"
            case .waze:
                return "Waze"
            }
        }
    }
}

// MARK: - Private

private extension ExternalMappingURLBuilder.MapApp {
    var interface: MapAppURLBuilder.Type {
        switch self {
        case .apple:
            return AppleMapsURLBuilder.self
        case .google:
            return GoogleMapsURLBuilder.self
        case .waze:
            return WazeURLBuilder.self
        }
    }
}
