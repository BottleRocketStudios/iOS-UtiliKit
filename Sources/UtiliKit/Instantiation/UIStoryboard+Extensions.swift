//
//  UIStoryboard+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    
    /// A small struct used to represent the name and bundle of a storyboad object.
    struct Identifier {
        public let name: String
        public let bundle: Bundle
        
        /**
         Identifying information for storyboards
         
         - Parameter name: The name of the storyboard.
         - Parameter bundle: The bundle of the storyboard.
         */
        public init(name: String, bundle: Bundle = Bundle.main) {
            self.name = name
            self.bundle = bundle
        }
    }
    
    /**
     Convenience initializer for storyboards
     
     - Parameter identifier: The name and bundle of a storyboard.
    */
    convenience init(identifier: UIStoryboard.Identifier) {
        self.init(name: identifier.name, bundle: identifier.bundle)
    }
    
    /**
     Returns the initial view controller of type T.
    
     - Returns: A view controller of type T.
    */
    func instantiateInitialViewController<T: UIViewController>() -> T {
        guard let vc = instantiateInitialViewController() as? T else {
            fatalError("Unable to instantiate the initial view controller as \(T.self) from storyboard \(self)")
        }
        
        return vc
    }
    
    /**
     Returns the initial view controller of type T configured with `element`.
     
     - Parameter element: An element of the appropriate type, used to configure the view controller.
     - Returns: A view controller of type T.
     */
    func instantiateInitialViewController<T: UIViewController & Configurable>(configuredWith element: T.ConfiguringType) -> T {
        let vc: T = instantiateInitialViewController()
        vc.configure(with: element)
        
        return vc
    }
    
    /**
     Returns a view controller of type T.
    
     - Returns: A view controller of type T.
    */
    func instantiateViewController<T: UIViewController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Unable to instantiate a view controller with identifier \(T.storyboardIdentifier) from storyboard \(self)")
        }
        
        return vc
    }
    
    /**
     Returns the initial view controller of type T configured with `element`.
     
     - Parameter element: An element of the appropriate type, used to configure the view controller.
     - Returns: A view controller of type T.
     */
    func instantiateViewController<T: UIViewController & Configurable>(configuredWith element: T.ConfiguringType) -> T {
        let vc: T = instantiateViewController()
        vc.configure(with: element)
        
        return vc
    }
}
