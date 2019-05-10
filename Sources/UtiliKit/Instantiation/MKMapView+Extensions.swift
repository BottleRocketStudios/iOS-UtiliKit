//
//  MKMapView+Reusable.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import MapKit

public extension MKMapView {
    
    //MARK: Registration
    /**
    Registers an annotation view for a map view.
     
    - Parameter type: The type of the view being registered
     */
    @available(iOS 11.0, *)
    func register<T: MKAnnotationView>(_ type: T.Type) {
        register(type, forAnnotationViewWithReuseIdentifier: T.reuseIdentifier)
    }
    
    //MARK: Dequeue
    /**
     Returns a reusable annotation view of type T.
    
     - Parameter annotation: The annotation of the annotation view.
     - Returns: An annotation view of type T.
     */
    @available(iOS 11.0, *)
    func dequeueReusableAnnotationView<T: MKAnnotationView>(for annotation: MKAnnotation) -> T {
        guard let annotationView = dequeueReusableAnnotationView(withIdentifier: T.reuseIdentifier, for: annotation) as? T else {
            fatalError("Could not dequeue a reusable annotation of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
        }
        
        return annotationView
    }
    
    /**
     Returns a reusable annotation view of type T.
     
     - Parameter annotation: The annotation of the annotation view.
     - Parameter element: An object used to configure the newly dequeued cell.
     - Returns: An annotation view of type T configured with `element`.
     */
    @available(iOS 11.0, *)
    func dequeueReusableAnnotationView<T: MKAnnotationView & Configurable>(for annotation: MKAnnotation, configuredWith element: T.ConfiguringType) -> T {
        let annotationView: T = dequeueReusableAnnotationView(for: annotation)
        annotationView.configure(with: element)
        
        return annotationView
    }
    
    /**
     Returns a reusable, optional annotation view  of type T.
    
     - Returns: Either a reusable annotation view of type T or a new instance of it.
    */
    func dequeueReusableAnnotationView<T: MKAnnotationView>() -> T {
        let annotationView: MKAnnotationView? = dequeueReusableAnnotationView(withIdentifier: T.reuseIdentifier)
        
        if let annotationView = annotationView {
            guard let customAnnotationView = annotationView as? T else {
                fatalError("Could not dequeue a reusable annotation of type \(T.self) with identifier \(T.reuseIdentifier) for use in \(self)")
            }
            
            return customAnnotationView
        }
        
        return T()
    }
    
    /**
     Returns a reusable, optional annotation view  of type T.
     
     - Parameter element: An object used to configure the newly dequeued cell.
     - Returns: Either a reusable annotation view of type T or a new instance of it, configured with `element`.
     */
    func dequeueReusableAnnotationView<T: MKAnnotationView & Configurable>(configuredWith element: T.ConfiguringType) -> T {
        let annotationView: T = dequeueReusableAnnotationView()
        annotationView.configure(with: element)
        
        return annotationView
    }
}
