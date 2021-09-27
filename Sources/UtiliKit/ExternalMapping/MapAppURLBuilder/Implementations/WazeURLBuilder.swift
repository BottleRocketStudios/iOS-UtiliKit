//
//  WazeURLBuilder.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/25/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// Builds links to Waze app based on https://developers.google.com/waze/deeplinks/
enum WazeURLBuilder {

    /// Generate a URL to a location in the Waze app with the specified parameters
    /// - Parameters:
    ///   - query: Search term or address to look up on the map.
    ///   - coordinate: Location to display or location to search near if a `query` is specified.
    ///   - zoom: The zoom level.
    /// - Returns: URL to the Waze app
    static func location(query: String? = nil,
                         coordinate: Coordinate? = nil,
                         zoom: Float? = nil) -> URL {
        var urlComponents = baseURLComponents
        if let query = percentEncoded(query) {
            urlComponents?.addQueryItem(.init(parameter: .query, value: query))
        }
        if let coordinate = coordinate,
           let coordinateString = percentEncoded("\(coordinate.latitude),\(coordinate.longitude)") {
            urlComponents?.addQueryItem(.init(parameter: .coordinates, value: coordinateString))
        }
        if let zoom = zoom,
           let zoomString = percentEncoded("\(zoom)") {
            urlComponents?.addQueryItem(.init(parameter: .zoom, value: zoomString))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Generate a URL to a location in the Waze app with the specified parameters
    /// - Parameters:
    ///   - favorite: One of the user's saved locations.
    ///   - zoom: The zoom level.
    /// - Returns: URL to the Waze app
    static func location(favorite: Favorite,
                         zoom: Float? = nil) -> URL {
        var urlComponents = URLComponents(string: location(zoom: zoom).absoluteString)
        if let favorite = percentEncoded(favorite.rawValue) {
            urlComponents?.addQueryItem(.init(parameter: .favorite, value: favorite))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Generate a URL to navigation directions in the Waze app with the specified parameters
    /// - Parameters:
    ///   - query: Search term or address to look up on the map.
    ///   - coordinate: Location to display or location to search near if a `query` is specified.
    ///   - zoom: The zoom level.
    /// - Returns: URL to the Waze app
    static func directions(query: String? = nil,
                           coordinate: Coordinate? = nil,
                           zoom: Float? = nil) -> URL {
        var urlComponents = URLComponents(string: location(query: query, coordinate: coordinate, zoom: zoom).absoluteString)
        urlComponents?.addQueryItem(.init(parameter: .navigate, value: "yes"))
        return urlComponents?.url ?? baseURL
    }

    /// Generate a URL to navigation directions in the Waze app with the specified parameters
    /// - Parameters:
    ///   - favorite: One of the user's saved locations.
    ///   - zoom: The zoom level.
    /// - Returns: URL to the Waze app
    static func directions(favorite: Favorite,
                           zoom: Float? = nil) -> URL {
        var urlComponents = URLComponents(string: location(favorite: favorite, zoom: zoom).absoluteString)
        urlComponents?.addQueryItem(.init(parameter: .navigate, value: "yes"))
        return urlComponents?.url ?? baseURL
    }
}

// MARK: MapAppURLBuilder

extension WazeURLBuilder: MapAppURLBuilder {

    static var zoomRange: ClosedRange<Float> { Float(6)...8192 }
    static var launchAppURL: URL { baseURL }

    static func displayLocation(at coordinate: Coordinate, zoomPercent: Float?, style: MapStyle?) -> URL {
        location(coordinate: coordinate, zoom: zoomValue(fromPercent: zoomPercent))
    }

    static func search(for query: String, near coordinate: Coordinate?, style: MapStyle?) -> URL {
        location(query: query, coordinate: coordinate)
    }

    static func navigate(to toAddress: String, from fromAddress: String?, via navigationMode: NavigationMode?, style: MapStyle?) -> URL {
        directions(query: toAddress)
    }
}

// MARK: - WazeURLBuilder.Coordinates

extension WazeURLBuilder {
    enum Favorite: String {
        case home
        case work
    }
}

// MARK: - Private

private extension WazeURLBuilder {
    static var baseURL: URL {
        guard let url = URL(string: "waze://") else {
            fatalError("Could not build the base URL to Waze")
        }
        return url
    }

    static var baseURLComponents: URLComponents? {
        URLComponents(string: baseURL.absoluteString)
    }

    static func percentEncoded(_ string: String?) -> String? {
        string?.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

// MARK: Convenience

private extension URLQueryItem {

    init(parameter: WazeParameter, value: String?) {
        self.init(name: parameter.rawValue, value: value)
    }

    var parameterName: WazeParameter? {
        .init(rawValue: name)
    }

    enum WazeParameter: String {
        case coordinates = "ll"
        case navigate = "navigate"
        case zoom = "z"
        case favorite = "favorite"
        case query = "q"
    }
}
