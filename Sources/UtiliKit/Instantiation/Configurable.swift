//
//  Configurable.swift
//  UtiliKit
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation

//MARK: Configurable
public protocol Configurable {
    associatedtype ConfiguringType
    
    /// Configures `Self` with `element`.
    func configure(with element: ConfiguringType)
}
