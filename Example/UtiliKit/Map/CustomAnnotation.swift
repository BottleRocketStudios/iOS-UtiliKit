//
//  CustomAnnotation.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import MapKit

/**
 Example annotation view used in the example showcasing how to programmatically register and dequeue annotation views.
 
 Check out MapController to see how the cells are registered in a type-safe fashion.
 */
class CustomAnnotation: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 11.0, *) {
            clusteringIdentifier = "annotation"
        }
        
        backgroundColor = .red
        bounds = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
