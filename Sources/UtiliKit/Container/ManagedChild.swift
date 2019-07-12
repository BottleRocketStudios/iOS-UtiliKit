//
//  ManagedChild.swift
//  UtiliKit-iOS
//
//  Created by Cuong Ngo on 8/14/18.
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public protocol ManagedChild {
    var identifier: AnyHashable { get }
    var viewController: UIViewController { get }
}

//MARK: Simple Child Implementation
public struct Child: ManagedChild {
    public let identifier: AnyHashable
    public let viewController: UIViewController
    
    public init(identifier: AnyHashable, viewController: UIViewController) {
        self.identifier = identifier
        self.viewController = viewController
    }
    
    public init<T: RawRepresentable>(title: T, viewController: UIViewController) where T.RawValue == String {
        self.init(identifier: title.rawValue, viewController: viewController)
    }
}
