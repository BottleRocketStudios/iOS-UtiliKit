//
//  UISegmentedControl+Extensions.swift
//  UtiliKit-iOSTests
//
//  Created by Nathan Chiu on 9/26/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import UIKit

public extension UISegmentedControl {
    
    public var titleOfSelectedSegment: String? {
        titleForSegment(at: selectedSegmentIndex)
    }
}
