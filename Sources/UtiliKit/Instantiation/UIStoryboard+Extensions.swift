//
//  UIStoryboard+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    
    /// A small struct used to represent the name and bundle of a storyboad object.
    public struct Identifier {
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
    public func instantiateInitialViewController<T: UIViewController>() -> T {
        guard let vc = instantiateInitialViewController() as? T else {
            fatalError("Unable to instantiate the initial view controller as \(T.self) from storyboard \(self)")
        }
        
        return vc
    }
    
    /**
     Returns a view controller of type T.
    
     - Returns: A view controller of type T.
    */
    public func instantiateViewController<T: UIViewController>() -> T {
        guard let vc = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Unable to instantiate a view controller with identifier \(T.storyboardIdentifier) from storyboard \(self)")
        }
        
        return vc
    }
}
