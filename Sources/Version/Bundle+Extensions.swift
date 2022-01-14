//
//  Bundle+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import UIKit

public extension Bundle {
	
    /// Error thrown when version lookup fails
    struct VersionLookupError: Error {
		public let versionKey: String
		public var localizedDescription: String {
			let localizedVersionString = NSLocalizedString("Could not find Info.plist key: '%@' of type \(String.self)", comment: "Version Lookup Error - %@ will be replaced with a the key used")
			return String.localizedStringWithFormat(localizedVersionString, "\(versionKey)")
		}
	}
	
	/**
     Returns the version number of the application. EX. 5.0.1
     
     Short Version EX. 5.0.1.123
     
     - Parameter configuration: Defaults to the standard config. This struct defines the keys used for fetching the version number
     - Parameter isShortVersion: A Bool value used to switch between the short and long version
	*/
    func versionString(for configuration: VersionConfig = VersionConfig(), isShortVersion: Bool = false) throws -> String {
		let key = isShortVersion ? configuration.shortVersionKey : configuration.primaryVersionKey
		guard let versionString = object(forInfoDictionaryKey: key) as? String else { throw VersionLookupError(versionKey: key) }
		
		return versionString
	}
	
	/**
     Returns the verbose version number of the application. EX. version 5.0.1.123DE🐞 Debug
     
     Short Version EX. version 5.0.1DE🐞 Debug
     
     - Parameter configuration: Defaults to the standard config. This struct defines the keys used for fetching the version number
     - Parameter isShortVersion: A Bool value used to switch between the short and long version
     - Parameter showDebugSymbol: A Bool value used to determine the use of the bug symbol for debug builds
	*/
    func verboseVersionString(for configuration: VersionConfig = VersionConfig(), isShortVersion: Bool = false, showDebugSymbol: Bool = false) throws -> String {
		
		let version = try versionString(for: configuration, isShortVersion: isShortVersion)
		let environment = configuration.environmentName ?? ""
		
		let localizedVersionString = NSLocalizedString("version %@", comment: "Version string - %@ will be replaced with a version number. EX. 5.0.1")
		let formatString = String.localizedStringWithFormat(localizedVersionString, "\(version) \(environment)")
		
		return formatString
	}
}
