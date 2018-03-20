//
//  VersionConfig.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import UIKit

/// Struct used to define the keys used in fetching the version number as well as the environment name
public struct VersionConfig {
    public let environmentName: String?
    public let primaryVersionKey: String
    public let shortVersionKey: String
    
    /**
     Creates a Version config
     
     - Parameter primaryVersionKey: Defaults to "CFBundleVersion." This is the plist key used to find the version number.
     - Parameter shortVersionKey: Defaults to "CFBundleShortVersionString." This is the plist key used to find the short version number.
     - Parameter environmentName: Defaults to nil. This is the name of the current environment.
    */
    public init(primaryVersionKey: String = "CFBundleVersion", shortVersionKey: String = "CFBundleShortVersionString", environmentName: String? = nil) {
        self.primaryVersionKey = primaryVersionKey
        self.shortVersionKey = shortVersionKey
        self.environmentName = environmentName
    }
}
