//
//  ManagedChild.swift
//  UtiliKit-iOS
//
//  Created by Cuong Ngo on 8/14/18.
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

//MARK: Simple Child Implementation
public struct Child<Identifier: Hashable> {
    
    // MARK: Properties
    public let identifier: Identifier
    public let viewController: UIViewController
    
    public init(identifier: Identifier, viewController: UIViewController) {
        self.identifier = identifier
        self.viewController = viewController
    }
}
