//
//  MapViewController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import MapKit

/**
 Example view controller used in the example showcasing how to programmatically register and dequeue annotation views.
 
 Check out MapController to see how the cells are registered in a type-safe fashion.
 */
class MapViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    private var mapController: MapController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapController = MapController(mapView)
    }
}
