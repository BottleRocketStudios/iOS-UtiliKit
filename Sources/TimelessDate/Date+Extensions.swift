//
//  Date+Extensions.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Current date and time.
    static var now: Date { return Date() }
    
    /// Date and time of Midnight January 1, 2001.
    static var reference2001: Date { return Date(timeIntervalSinceReferenceDate: 0) }
    
    /// Date and time of Midnight January 1, 1970.
    static var reference1970: Date { return Date(timeIntervalSince1970: 0) }
    
    /**
     Creates a Date initialized relative to another given date by a given number of days, hours, minutes, and seconds.
     
     All values except the reference date default to 0
     
     - Parameter days: The number of whole days to be added
     - Parameter hours: The number of whole hours to be added.
     - Parameter minutes: The number of whole minutes to be added.
     - Parameter seconds: The number of seconds to be added.
     - Parameter date: The reference Date
    */
    init?(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0, since date: Date) {
        var components = DateComponents()
        components.day = days
        components.hour = hours
        components.minute = minutes
        components.second = seconds
        
        guard let newDate = Calendar.current.date(byAdding: components, to: date) else { return nil }
        self.init(timeInterval: 0, since: newDate)
    }
    
    /**
     Adds a number of days, hour, minutes, and seconds to the date and time.
    
     - Parameter days: The number of whole days to be added
     - Parameter hours: The number of whole hours to be added.
     - Parameter minutes: The number of whole minutes to be added.
     - Parameter seconds: The number of seconds to be added.
     - Returns: An optional Date with the given values added to it.
     */
    func adding(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return Date(days: days, hours: hours, minutes: minutes, seconds: seconds, since: self)
    }
    
    /**
     Subtracts a number of days, hour, minutes, and seconds to the date and time.
    
     - Parameter days: The number of whole days to be subtracted
     - Parameter hours: The number of whole hours to be subtracted.
     - Parameter minutes: The number of whole minutes to be subtracted.
     - Parameter seconds: The number of seconds to be subtracted.
     - Returns: An optional Date with the given values subtracted to it.
    */
    func subtracting(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return Date(days: -days, hours: -hours, minutes: -minutes, seconds: -seconds, since: self)
    }
}
