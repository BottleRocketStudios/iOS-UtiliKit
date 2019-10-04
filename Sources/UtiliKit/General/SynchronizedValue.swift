//
//  SynchronizedValue.swift
//  UtiliKit-iOS
//
//  Created by Pranjal Satija on 10/4/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

@propertyWrapper
struct SynchronizedValue<T> {
    let queue = DispatchQueue(label: UUID().uuidString)
    
    init(wrappedValue: T) {
        _wrappedValue = wrappedValue
    }
    
    private var _wrappedValue: T
    var wrappedValue: T {
        get {
            var wrappedValue: T!
            
            queue.sync {
                wrappedValue = _wrappedValue
            }
            
            return wrappedValue
        }
        
        set {
            queue.sync {
                _wrappedValue = newValue
            }
        }
    }
}
