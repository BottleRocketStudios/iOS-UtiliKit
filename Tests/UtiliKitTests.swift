//
//  UtiliKitTests.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import XCTest
import CoreLocation
@testable import UtiliKit

class OpenSourceUtilitiesTests: XCTestCase {
    var view: UIView!
    var superview: UIView!
    
    override func setUp() {
        super.setUp()
        
        superview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view = UIView(frame: .zero)
    }
    
    override func tearDown() {
        view = nil
        superview = nil
        
        super.tearDown()
    }
    
    //MARK: - Subview Tests
    @available(iOS 11, *)
    func test_AddSubview_TranslatesAutoresizingMaskIntoConstraintsIsFalse() {
        superview.addSubview(view, constrainedToSuperview: true, usingSafeArea: true)
        
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
    }
    
    @available(iOS 11, *)
    func test_AddSubview_ConstraintsAdded() {
        superview.addSubview(view, constrainedToSuperview: true, usingSafeArea: false)
        
        XCTAssertEqual(superview.constraints.count, 4)
    }
    
    @available(iOS 11, *)
    func test_ConstrainSubview_ConstraintsAdded() {
        superview.addSubview(view)
        view.centerViewInSuperview(usingSafeArea: true)
        
        XCTAssertEqual(superview.constraints.count, 2)
    }
    
    func test_ConstrainSubviewWithInsets_InsetsAddedInCorrectDirection() {
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.constrainEdgesToSuperview(with: insets)
        
        superview.setNeedsLayout()
        superview.layoutIfNeeded()
        
        XCTAssertEqual(superview.bounds.inset(by: insets), view.frame)
    }
    
    @available(iOS 11, *)
    func test_ConstrainSubviewInsideSafeAreaWithInsets_InsetsAddedInCorrectDirection() {
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.constrainEdgesToSuperview(with: insets, usingSafeArea: false)
        
        superview.setNeedsLayout()
        superview.layoutIfNeeded()
        
        XCTAssertEqual(superview.bounds.inset(by: insets), view.frame)
    }

    //MARK: - CLLocationCoordinate2D Tests
    func test_CLLocationCoordinate2D_Valid() {
        let coordinates = [CLLocationCoordinate2D(latitude: CLLocationDegrees(0),
                                                  longitude: CLLocationDegrees(0)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(-0),
                                                  longitude: CLLocationDegrees(-0)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(90),
                                                  longitude: CLLocationDegrees(180)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(-90),
                                                  longitude: CLLocationDegrees(180)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(90),
                                                  longitude: CLLocationDegrees(-180)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(-90),
                                                  longitude: CLLocationDegrees(-180))
        ]

        XCTAssertNil(coordinates.first { !$0.isValid })
    }

    func test_CLLocationCoordinate2d_Invalid() {
        let coordinates = [CLLocationCoordinate2D(latitude: CLLocationDegrees(95),
                                                  longitude: CLLocationDegrees(0)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(-95),
                                                  longitude: CLLocationDegrees(0)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(0),
                                                  longitude: CLLocationDegrees(185)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(0),
                                                  longitude: CLLocationDegrees(-185)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(95),
                                                  longitude: CLLocationDegrees(185)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(-95),
                                                  longitude: CLLocationDegrees(185)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(95),
                                                  longitude: CLLocationDegrees(-185)),
                           CLLocationCoordinate2D(latitude: CLLocationDegrees(-95),
                                                  longitude: CLLocationDegrees(-185))
        ]

        let invalidCoordinates = coordinates.filter { !$0.isValid}
        XCTAssertTrue(coordinates.count == invalidCoordinates.count, "All test coordinates should be invalid")
    }
}
