//
//  StoryboardIdentifiable.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import UIKit

//MARK: Storyboard Identifiable
public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
    
    /// The storyboard identifier of a view controller defaults to that view controller's String(describing: self)
    public static var storyboardIdentifier: String { return String(describing: self) }
}
