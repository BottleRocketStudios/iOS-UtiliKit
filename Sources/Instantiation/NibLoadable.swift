//
//  NibLoadable.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

//MARK: NibLoadable
public protocol NibLoadable {
    
    /// An identifier used to load this class's nib
    static var nibName: String { get }
}

extension NibLoadable {
    
    /**
     Loads nib of type T
    
     - Returns: An instance of the nib associated with a class T.
    */
    public static func instanceFromNib<T: UIView>() -> T {
        guard let instance = UINib(nibName: T.nibName, bundle: Bundle(for: T.classForCoder())).instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Could load an instance from nib of type \(T.self)")
        }
        
        return instance
    }
}

extension UIView: NibLoadable {
    
    /// The nibName of a view defaults to that view's String(describing: self)
    public static var nibName: String { return String(describing: self) }
}
