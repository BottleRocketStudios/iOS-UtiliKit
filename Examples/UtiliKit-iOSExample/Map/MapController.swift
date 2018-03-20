//
//  MapController.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import MapKit

/**
 Example map controller showcasing how to programmatically register and dequeue annotation views.
 Check out how the CustomAnnotations are registered with the map view in the 'init()' method below.
 Then check out how the annotations are dequeued in the 'mapView(_:, viewFor:)' MKMapViewDelegate method below.
 */
class MapController: NSObject {
    private let mapView: MKMapView
    let coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 32.9485038745458, longitude: -96.8236553048684)]
    
    init(_ mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        
        let home = CLLocationCoordinate2D(latitude: 32.949, longitude: -96.824)
        let region = MKCoordinateRegion(center: home, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
        mapView.setRegion(region, animated: true)
        
        // Register annotations programmatically.
        // Notice how the type of the annotation is all that's needed to register your class with the map view.
        // The extension on MKMapView will automatically use the name of the class to load the view from the bundle and register it with the map view.
        if #available(iOS 11.0, *) {
            mapView.register(CustomAnnotation.self)
        }
        
        mapView.delegate = self
        coordinates.forEach { addAnnotation(for: $0, title: "Red") }
    }
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
}

// MARK: - MKMapViewDelegate
extension MapController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Dequeue a "CustomAnnotation" from the map view
        // Notice that the desired type of annotation view that you want to dequeue must be provided.
        // The MKMapView extension will automatically attempt to dequeue an annotation with a reuse identifier that matches the name of the annotation's type and then cast it into that type.
        if #available(iOS 11.0, *) {
            let annotationView: CustomAnnotation = mapView.dequeueReusableAnnotationView(for: annotation)
            return annotationView
        } else {
            return nil
        }
    }
}
