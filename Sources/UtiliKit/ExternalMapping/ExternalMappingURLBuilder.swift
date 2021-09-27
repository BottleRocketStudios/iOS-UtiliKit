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

    let supportedApps: [MapApp]

    // MARK: Initializers

    public init(supportedApps: [MapApp]) {
        self.supportedApps = supportedApps
    }

    // MARK: Public

    public func displayLocation(at coordinate: MappingCoordinate, zoomPercent: Float?, style: MapStyle?) -> [MapApp: URL] {
        var returnDictionary = [MapApp: URL]()
        supportedApps.forEach {
            returnDictionary[$0] = $0.interface.displayLocation(at: coordinate, zoomPercent: zoomPercent, style: style)
        }
        return returnDictionary
    }

    public func search(for query: String, near coordinate: MappingCoordinate?, style: MapStyle?) -> [MapApp: URL] {
        var returnDictionary = [MapApp: URL]()
        supportedApps.forEach {
            returnDictionary[$0] = $0.interface.search(for: query, near: coordinate, style: style)
        }
        return returnDictionary
    }

    public func navigate(to toAddress: String, from fromAddress: String?, via navigationMode: NavigationMode?, style: MapStyle?) -> [MapApp: URL] {
        var returnDictionary = [MapApp: URL]()
        supportedApps.forEach {
            returnDictionary[$0] = $0.interface.navigate(to: toAddress, from: fromAddress, via: navigationMode, style: style)
        }
        return returnDictionary
    }
}

// MARK: - ExternalMappingURLBuilder.MapApp

public extension ExternalMappingURLBuilder {
    enum MapApp: CaseIterable {
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

//private extension ExternalMappingURLBuilder {
//
//}

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
