//
//  AppleMapsURLBuilder.swift
//  UtiliKit-iOS
//
//  Created by Nathan Chiu on 9/24/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// Builds links to Apple Maps app based on https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
enum AppleMapsURLBuilder {

    /// Generate a URL to a location in the Apple Maps app with the specified parameters
    /// - Parameters:
    ///   - mapType: The map type. If unspecified, the current map type is used.
    ///   - query: The query. This parameter is treated as if its value had been typed into the Maps search field by the user. Note that `q=*` is not supported. A string that describes the search object, such as “pizza,” or an address to be geocoded.
    ///   - address: The address. Using the `address` simply displays the specified location, it does not perform a search for the location.
    ///   - near: A hint used during search.
    ///   - coordinate: The location around which the map should be centered. The `coordinate` can also represent a pin location when you use the `query` parameter to specify a name.
    /// - Returns: URL to the Apple Maps app
    static func location(mapType: MapType? = nil,
                         query: String? = nil,
                         address: String? = nil,
                         near: Coordinate? = nil,
                         coordinate: Coordinate? = nil) -> URL {
        var urlComponents = baseURLComponents
        if let mapType = percentEncoded(mapType?.rawValue) {
            urlComponents?.addQueryItem(.init(parameter: .mapType, value: mapType))
        }
        if let query = percentEncoded(query) {
            urlComponents?.addQueryItem(.init(parameter: .query, value: query))
        }
        if let address = percentEncoded(address) {
            urlComponents?.addQueryItem(.init(parameter: .address, value: address))
        }
        if let nearString = percentEncoded(near?.stringValue) {
            urlComponents?.addQueryItem(.init(parameter: .near, value: nearString))
        }
        if let coordinateString = percentEncoded(coordinate?.stringValue) {
            urlComponents?.addQueryItem(.init(parameter: .location, value: coordinateString))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Generate a URL to a location in the Apple Maps app with the specified parameters
    /// - Parameters:
    ///   - mapType: The map type. If unspecified, the current map type is used.
    ///   - query: The query. This parameter is treated as if its value had been typed into the Maps search field by the user. Note that `q=*` is not supported. A string that describes the search object, such as “pizza,” or an address to be geocoded.
    ///   - address: The address. Using the `address` simply displays the specified location, it does not perform a search for the location.
    ///   - near: A hint used during search.
    ///   - coordinate: The location around which the map should be centered. The `coordinate` can also represent a pin location when you use the `query` parameter to specify a name.
    ///   - zoom: The zoom level. You can use `zoom` only when you also specify `coordinates`.
    /// - Returns: URL to the Apple Maps app
    static func location(mapType: MapType? = nil,
                         query: String? = nil,
                         address: String? = nil,
                         near: Coordinate? = nil,
                         coordinate: Coordinate? = nil,
                         zoom: Float?) -> URL {
        let url = location(mapType: mapType, query: query, address: address, near: near, coordinate: coordinate)
        var urlComponents = URLComponents(string: url.absoluteString)
        if let zoom = zoom, zoomRange.contains(zoom), let zoomString = percentEncoded("\(zoom)") {
            urlComponents?.addQueryItem(.init(parameter: .zoomLevel, value: zoomString))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Generate a URL to a location in the Apple Maps app with the specified parameters
    /// - Parameters:
    ///   - mapType: The map type. If unspecified, the current map type is used.
    ///   - query: The query. This parameter is treated as if its value had been typed into the Maps search field by the user. Note that `q=*` is not supported. A string that describes the search object, such as “pizza,” or an address to be geocoded.
    ///   - address: The address. Using the `address` simply displays the specified location, it does not perform a search for the location.
    ///   - near: A hint used during search.
    ///   - coordinate: The location around which the map should be centered. The `coordinate` can also represent a pin location when you use the `query` parameter to specify a name.
    ///   - span: The area around the center point. The center point is specified by `coordinates`.
    /// - Returns: URL to the Apple Maps app
    static func location(mapType: MapType? = nil,
                         query: String? = nil,
                         address: String? = nil,
                         near: Coordinate? = nil,
                         coordinate: Coordinate? = nil,
                         span: Span?) -> URL {
        let url = location(mapType: mapType, query: query, address: address, near: near, coordinate: coordinate)
        var urlComponents = URLComponents(string: url.absoluteString)
        if let spanString = percentEncoded(span?.stringValue) {
            urlComponents?.addQueryItem(.init(parameter: .span, value: spanString))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Generate a URL to get directions in the Apple Maps app with the specified parameters
    /// - Parameters:
    ///   - destinationAddress: The destination address to be used as the destination point for directions.
    ///   - startAddress: The source address to be used as the starting point for directions.
    ///   - transportationMode: The transport type. If unspecified, Maps uses the user’s preferred transport type or the previous setting.
    ///   - mapType: The map type. If unspecified, the current map type is used.
    /// - Returns: URL to the Apple Maps app
    static func directions(to destinationAddress: String,
                           from startAddress: String? = nil,
                           by transportationMode: TransportationMode? = nil,
                           mapType: MapType? = nil) -> URL {
        let url = location(mapType: mapType)
        var urlComponents = URLComponents(string: url.absoluteString)
        if let destinationAddress = percentEncoded(destinationAddress) {
            urlComponents?.addQueryItem(.init(parameter: .destinationAddress, value: destinationAddress))
        }
        if let startAddress = percentEncoded(startAddress) {
            urlComponents?.addQueryItem(.init(parameter: .startAddress, value: startAddress))
        }
        if let transportationMode = percentEncoded(transportationMode?.rawValue) {
            urlComponents?.addQueryItem(.init(parameter: .transportationMode, value: transportationMode))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Generate a URL to perform a search in the Apple Maps app with the specified parameters
    /// - Parameters:
    ///   - query: The query. This parameter is treated as if its value had been typed into the Maps search field by the user. Note that `q=*` is not supported. A string that describes the search object, such as “pizza,” or an address to be geocoded.
    ///   - near: A hint used during search. If the `location` parameter is missing or its value is incomplete, the value of `near` is used instead.
    ///   - location: The latitude and longitude of the search location.
    ///   - span: The latitudinal delta and a longitudinal delta of the screen span around the search location specified by the `location` parameter.
    ///   - mapType: The map type. If unspecified, the current map type is used.
    /// - Returns: URL to the Apple Maps app
    static func search(query: String? = nil,
                       near: Coordinate? = nil,
                       location: Coordinate? = nil,
                       span: Span? = nil,
                       mapType: MapType? = nil) -> URL {
        let url = AppleMapsURLBuilder.location(mapType: mapType, query: query, near: near)
        var urlComponents = URLComponents(string: url.absoluteString)
        if let location = location,
           let locationString = percentEncoded("\(location.latitude),\(location.longitude)") {
            urlComponents?.addQueryItem(.init(parameter: .searchLocation, value: locationString))
            if let nearIndex = urlComponents?.queryItems?.firstIndex(where: { $0.parameterName == .near }) {
                urlComponents?.queryItems?.remove(at: nearIndex)
            }
        }
        if let span = span,
           let spanString = percentEncoded("\(span.latitudeDelta),\(span.longitudeDelta)") {
            urlComponents?.addQueryItem(.init(parameter: .screenSpan, value: spanString))
        }
        return urlComponents?.url ?? baseURL
    }

    /// Drops a named pin on the map at the specified coordinates
    /// - Parameters:
    ///   - coordinate: Location to display the pin.
    ///   - title: Title displayed on the pin.
    ///   - zoom: The zoom level.
    ///   - mapType: The map type. If unspecified, the current map type is used.
    /// - Returns: URL to the Apple Maps app
    static func dropPin(at coordinate: Coordinate, titled title: String, zoom: Float? = nil, mapType: MapType? = nil) -> URL {
        location(mapType: mapType, query: title, coordinate: coordinate, zoom: zoom)
    }
}

// MARK: MapAppURLBuilder

extension AppleMapsURLBuilder: MapAppURLBuilder {
    static var launchAppURL: URL { baseURL }
    static var zoomRange: ClosedRange<Float> { Float(2)...21 }

    static func displayLocation(at coordinate: Coordinate, zoomPercent: Float?, style: MapStyle?) -> URL {
        location(mapType: .init(style: style), coordinate: coordinate, zoom: zoomValue(fromPercent: zoomPercent))
    }

    static func search(for query: String, near coordinate: Coordinate?, style: MapStyle?) -> URL {
        search(query: query, near: coordinate, mapType: .init(style: style))
    }

    static func navigate(to toAddress: String, from fromAddress: String?, via navigationMode: NavigationMode?, style: MapStyle?) -> URL {
        directions(to: toAddress, from: fromAddress, by: .init(navigationMode: navigationMode), mapType: .init(style: style))
    }
}

// MARK: - AppleMapsURLBuilder.MapType

extension AppleMapsURLBuilder {
    enum MapType: String {
        case standard = "m"
        case satellite = "k"
        case hybrid = "h"
        case transit = "r"

        init?(style: MapStyle?) {
            guard let style = style else { return nil }
            switch style {
            case .normal:
                self = .standard
            case .satellite:
                self = .satellite
            case .transit:
                self = .transit
            }
        }
    }
}

// MARK: - AppleMapsURLBuilder.TransportationMode

extension AppleMapsURLBuilder {
    enum TransportationMode: String {
        case car = "d"
        case foot = "w"
        case publicTransit = "r"

        init?(navigationMode: NavigationMode?) {
            guard let navigationMode = navigationMode else { return nil }
            switch navigationMode {
            case .bike:
                return nil
            case .car:
                self = .car
            case .transit:
                self = .publicTransit
            case .walk:
                self = .foot
            }
        }
    }
}

// MARK: - AppleMapsURLBuilder.Span

extension AppleMapsURLBuilder {
    struct Span {
        let latitudeDelta: Float
        let longitudeDelta: Float
        var stringValue: String { "\(latitudeDelta),\(longitudeDelta)" }
    }
}

// MARK: - Private

private extension AppleMapsURLBuilder {
    static var baseURL: URL {
        guard let url = URL(string: "maps://") else {
            fatalError("Could not build the base URL to Apple Maps")
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

    init(parameter: AppleMapsParameter, value: String?) {
        self.init(name: parameter.rawValue, value: value)
    }

    var parameterName: AppleMapsParameter? {
        .init(rawValue: name)
    }

    enum AppleMapsParameter: String {
        case mapType = "t"
        case query = "q"
        case address = "address"
        case near = "near"
        case location = "ll"
        case zoomLevel = "z"
        case span = "spn"
        case startAddress = "saddr"
        case destinationAddress = "daddr"
        case transportationMode = "dirflg"
        case searchLocation = "sll"
        case screenSpan = "sspn"
    }
}
