//
//  ReuseIdentifiable.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import MapKit

public protocol ReuseIdentifiable {
    
    /// An identifier used to store a class for reuse
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable where Self: UIView {
    
    /// The reuse identifier of a view defaults to that view's String(describing: self)
    public static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableViewCell: ReuseIdentifiable { }

extension MKAnnotationView: ReuseIdentifiable { }

extension UITableViewHeaderFooterView: ReuseIdentifiable { }

extension UICollectionReusableView: ReuseIdentifiable { }

