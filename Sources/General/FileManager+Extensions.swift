//
//  FileManager+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import Foundation
public extension FileManager {
    
    /// The URL for the documents directory.
    var documentsDirectory: URL {
        guard let documentDirectory = urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not locate Documents Directory.")
        }
        
        return documentDirectory
    }
    
    /// The URL for the chaches directory.
    var cachesDirectory: URL {
        guard let cachesDirectory = urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Could not locate Caches Directory.")
        }
        
        return cachesDirectory
    }
    
    /// The URL for the application support directory.
    var applicationSupportDirectory: URL {
        guard let applicationSupportDirectory = urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            fatalError("Could not locate Application Support Directory.")
        }
        
        return applicationSupportDirectory
    }
    
    /**
     A URL for the shared container within an app group.
     
     - Parameter groupIdentifier: The group identifier for the app group.
     - Returns: The URL for the shared container.
    */
    func sharedContainerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL {
        guard let sharedContainerURL = containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
            fatalError("Could not locate Shared Container URL.")
        }
        
        return sharedContainerURL
    }
}
