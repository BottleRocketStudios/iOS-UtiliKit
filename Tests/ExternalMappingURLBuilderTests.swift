//
//  ExternalMappingURLBuilderTests.swift
//  UtiliKit-iOSTests
//
//  Created by Nathan Chiu on 9/27/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import UtiliKit

class ExternalMappingURLBuilderTests: XCTestCase {

    let urlBuilder = ExternalMappingURLBuilder()
    let coordinate = MappingCoordinate(latitude: 32.949447, longitude: -96.823948)

    func test_mapAppTitles() {
        XCTAssertEqual(ExternalMappingURLBuilder.MapApp.apple.title, "Apple Maps")
        XCTAssertEqual(ExternalMappingURLBuilder.MapApp.google.title, "Google Maps")
        XCTAssertEqual(ExternalMappingURLBuilder.MapApp.waze.title, "Waze")
    }

    func test_displayLocation() {
        let mapLinks = urlBuilder.displayLocation(at: coordinate)
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?ll=32.949447,-96.823948")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?center=32.949447,-96.823948")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?ll=32.949447,-96.823948")
    }

    func test_displayLocationWithZoom() {
        let mapLinks = urlBuilder.displayLocation(at: coordinate, zoomPercent: 30)
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?ll=32.949447,-96.823948&z=7.7000003")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?center=32.949447,-96.823948&zoom=6.9")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?ll=32.949447,-96.823948&z=2461.8")
    }

    func test_displayLocationWithZoomAndStyle() {
        let mapLinks = urlBuilder.displayLocation(at: coordinate, zoomPercent: 30, style: .satellite)
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?t=k&ll=32.949447,-96.823948&z=7.7000003")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?center=32.949447,-96.823948&views=satellite&zoom=6.9")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?ll=32.949447,-96.823948&z=2461.8")
    }

    func test_searchFor() {
        let mapLinks = urlBuilder.search(for: "pizza")
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?q=pizza")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?q=pizza")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?q=pizza")
    }

    func test_searchForNear() {
        let mapLinks = urlBuilder.search(for: "pizza", near: coordinate)
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?q=pizza&near=32.949448,-96.82395")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?center=32.949448,-96.82395&q=pizza")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?q=pizza&ll=32.949448,-96.82395")
    }

    func test_searchForNearWithStyle() {
        let mapLinks = urlBuilder.search(for: "pizza", near: coordinate, style: .normal)
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?t=m&q=pizza&near=32.949448,-96.82395")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?center=32.949448,-96.82395&views=&q=pizza")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?q=pizza&ll=32.949448,-96.82395")
    }

    func test_getDirectionsTo() {
        let mapLinks = urlBuilder.navigate(to: "14841 Dallas Parkway")
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?daddr=14841+Dallas+Parkway")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?daddr=14841+Dallas+Parkway")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?q=14841+Dallas+Parkway&navigate=yes")
    }

    func test_getDirectionsToFrom() {
        let mapLinks = urlBuilder.navigate(to: "14841 Dallas Parkway", from: "4970 Addison Circle")
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?daddr=14841+Dallas+Parkway&saddr=4970+Addison+Circle")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?daddr=14841+Dallas+Parkway&saddr=4970+Addison+Circle")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?q=14841+Dallas+Parkway&navigate=yes")
    }

    func test_getDirectionsToFromVia() {
        let mapLinks = urlBuilder.navigate(to: "14841 Dallas Parkway", from: "4970 Addison Circle", via: .walk)
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?daddr=14841+Dallas+Parkway&saddr=4970+Addison+Circle&dirflg=w")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?daddr=14841+Dallas+Parkway&saddr=4970+Addison+Circle&directionsmode=walking")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?q=14841+Dallas+Parkway&navigate=yes")
    }

    func test_getDirectionsToFromViaWithStyle() {
        let mapLinks = urlBuilder.navigate(to: "14841 Dallas Parkway", from: "4970 Addison Circle", via: .walk, style: .transit)
        XCTAssertEqual(mapLinks[.apple]?.absoluteString, "maps://?t=m&daddr=14841+Dallas+Parkway&saddr=4970+Addison+Circle&dirflg=w")
        XCTAssertEqual(mapLinks[.google]?.absoluteString, "comgooglemaps://?views=&daddr=14841+Dallas+Parkway&saddr=4970+Addison+Circle&directionsmode=walking")
        XCTAssertEqual(mapLinks[.waze]?.absoluteString, "waze://?q=14841+Dallas+Parkway&navigate=yes")
    }
}
