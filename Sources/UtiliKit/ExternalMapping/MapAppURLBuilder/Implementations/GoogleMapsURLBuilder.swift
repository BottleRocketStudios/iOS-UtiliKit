//
//  GoogleMapsURLBuilder.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/24/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// Builds links to Google Maps app based on https://developers.google.com/maps/documentation/urls/ios-urlscheme
enum GoogleMapsURLBuilder {

    /// Use the URL scheme to display the map at a specified zoom level and location. You can also overlay other views on top of your map, or display Street View imagery.
    /// - Parameters:
    ///   - center: This is the map viewport center point.
    ///   - mapMode: Sets the kind of map shown. If not specified, the current application settings will be used.
    ///   - overlays: Turns specific views on/off. Multiple values can be set. If the parameter is specified with no value, then it will clear all views.
    ///   - zoom: Specifies the zoom level of the map.
    /// - Returns: URL to the Google Maps app
    static func location(center: Coordinate? = nil,
                         mapMode: MapMode? = nil,
                         overlays: [MapOverlay]? = nil,
                         zoom: Float? = nil) -> URL {
        var urlComponents = baseURLComponents
        if let center = percentEncoded(center?.stringValue) {
            urlComponents?.addQueryItem(.init(parameter: .center, value: center))
        }
        if let mapMode = percentEncoded(mapMode?.rawValue) {
            urlComponents?.addQueryItem(.init(parameter: .mapMode, value: mapMode))
        }
        if let overlays = overlays,
           let overlaysString = percentEncoded(overlays.map { $0.rawValue }.joined(separator: ",")) {
            urlComponents?.addQueryItem(.init(parameter: .mapType, value: overlaysString))
        }
        if let zoom = zoom,
           let zoomString = percentEncoded("\(zoom)") {
            urlComponents?.addQueryItem(.init(parameter: .zoomLevel, value: zoomString))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Used to display search queries in a specified viewport location.
    /// - Parameters:
    ///   - query: The query string for your search.
    ///   - center: This is the map viewport center point.
    ///   - mapMode: Sets the kind of map shown. If not specified, the current application settings will be used.
    ///   - overlays: Turns specific views on/off. Multiple values can be set. If the parameter is specified with no value, then it will clear all views.
    ///   - zoom: Specifies the zoom level of the map.
    /// - Returns: URL to the Google Maps app
    static func search(query: String? = nil,
                       center: Coordinate? = nil,
                       mapMode: MapMode? = nil,
                       overlays: [MapOverlay]? = nil,
                       zoom: Float? = nil) -> URL {
        var urlComponents = URLComponents(string: location(center: center, mapMode: mapMode, overlays: overlays, zoom: zoom).absoluteString)
        if let query = percentEncoded(query) {
            urlComponents?.addQueryItem(.init(parameter: .query, value: query))
        }
        return urlComponents?.url ?? baseURL
    }

    ///
    /// - Parameters:
    ///   - destination: Sets the end point for directions searches. If it is a query string that returns more than one result, the first result will be selected.
    ///   - start: Sets the starting point for directions searches. If it is a query string that returns more than one result, the first result will be selected. If the value is left blank, then the user’s current location will be used.
    ///   - transportationMode: Method of transportation.
    ///   - center: This is the map viewport center point.
    ///   - overlays: Turns specific views on/off. Multiple values can be set. If the parameter is specified with no value, then it will clear all views.
    ///   - zoom: Specifies the zoom level of the map.
    /// - Returns: URL to the Google Maps app
    static func directions(to destination: NavigationPoint,
                           from start: NavigationPoint? = nil,
                           transportationMode: TransportationMode? = nil,
                           center: Coordinate? = nil,
                           overlays: [MapOverlay]? = nil,
                           zoom: Float? = nil) -> URL {
        var urlComponents = URLComponents(string: location(center: center, overlays: overlays, zoom: zoom).absoluteString)
        if let destination = percentEncoded(destination.value) {
            urlComponents?.addQueryItem(.init(parameter: .destinationAddress, value: destination))
        }
        if let start = percentEncoded(start?.value) {
            urlComponents?.addQueryItem(.init(parameter: .startAddress, value: start))
        }
        if let transportationMode = percentEncoded(transportationMode?.rawValue) {
            urlComponents?.addQueryItem(.init(parameter: .transportationMode, value: transportationMode))
        }
        return urlComponents?.url ?? baseURL
    }
}

// MARK: MapAppURLBuilder

extension GoogleMapsURLBuilder: MapAppURLBuilder {
    static var launchAppURL: URL { baseURL }
    static var zoomRange: ClosedRange<Float> { Float(0)...23 }

    static func displayLocation(at coordinate: Coordinate, zoomPercent: Float?, style: MapStyle?) -> URL {
        location(center: coordinate, overlays: MapOverlay.from(style: style), zoom: zoomValue(fromPercent: zoomPercent))
    }

    static func search(for query: String, near coordinate: Coordinate?, style: MapStyle?) -> URL {
        search(query: query, center: coordinate, overlays: MapOverlay.from(style: style))
    }

    static func navigate(to toAddress: String, from fromAddress: String?, via navigationMode: NavigationMode?, style: MapStyle?) -> URL {
        var fromNavPoint: NavigationPoint?
        if let fromAddress = fromAddress {
            fromNavPoint = .address(fromAddress)
        }
        return directions(to: .address(toAddress), from: fromNavPoint, transportationMode: .init(navigationMode: navigationMode), overlays: MapOverlay.from(style: style))
    }
}

// MARK: - GoogleMapsURLBuilder.MapOverlay

extension GoogleMapsURLBuilder {
    enum MapOverlay: String {
        case satellite
        case traffic
        case transit

        static func from(style: MapStyle?) -> [MapOverlay]? {
            guard let style = style else { return nil }
            switch style {
            case .normal:
                return []
            case .satellite:
                return [.satellite]
            case .transit:
                return [.transit]
            }
        }
    }
}

// MARK: - GoogleMapsURLBuilder.MapMode

extension GoogleMapsURLBuilder {
    enum MapMode: String {
        case standard
        case streetView = "streetview"
    }
}

// MARK: - GoogleMapsURLBuilder.TransportationMode

extension GoogleMapsURLBuilder {
    enum TransportationMode: String {
        case bicycling
        case driving
        case transit
        case walking

        init?(navigationMode: NavigationMode?) {
            guard let navigationMode = navigationMode else { return nil }
            switch navigationMode {
            case .bike:
                self = .bicycling
            case .car:
                self = .driving
            case .transit:
                self = .transit
            case .walk:
                self = .walking
            }
        }
    }
}

// MARK: - GoogleMapsURLBuilder.NavigationPoint

extension GoogleMapsURLBuilder {
    enum NavigationPoint {
        case address(String)
        case coordinate(Coordinate)

        var value: String {
            switch self {
            case .address(let string):
                return string
            case .coordinate(let coordinate):
                return coordinate.stringValue
            }
        }
    }
}

// MARK: - GoogleMapsURLBuilder.Span

extension GoogleMapsURLBuilder {
    struct Span {
        let latitudeDelta: Float
        let longitudeDelta: Float
    }
}

// MARK: - Private

private extension GoogleMapsURLBuilder {
    static var baseURL: URL {
        guard let url = URL(string: "comgooglemaps://") else {
            fatalError("Could not build the base URL to Google Maps")
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

    init(parameter: GoogleMapsParameter, value: String?) {
        self.init(name: parameter.rawValue, value: value)
    }

    var parameterName: GoogleMapsParameter? {
        .init(rawValue: name)
    }

    enum GoogleMapsParameter: String {
        case center = "center"
        case mapMode = "mapmode"
        case mapType = "views"
        case zoomLevel = "zoom"
        case query = "q"
        case startAddress = "saddr"
        case destinationAddress = "daddr"
        case transportationMode = "directionsmode"
    }
}
