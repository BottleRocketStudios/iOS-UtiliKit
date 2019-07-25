//
//  TimelessDate.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import CoreFoundation

public typealias DateInterval = Int

extension Calendar {
    
    /**
     Returns the DateInterval between the given dates. A value of nil will be returned if there is an error with the given dates.
     
     - Parameter from: The starting date
     - Parameter to: The ending date
     - Returns: The difference in days between the starting and ending dates
    */
    func days(from: Date, to: Date) -> DateInterval? {
        guard let fromDay = date(from: dateComponents([.year, .month, .day], from: from)), let toDay = date(from: dateComponents([.year, .month, .day], from: to)) else { return nil }
        
        let components = dateComponents([.day], from: fromDay, to: toDay)
        return components.day
    }
}

/// A struct used for standardizing dates without times. This struct simplifies logic used to determine how many days away something is on a calendar as a person would understand them. This allevaites confusion and errors when converting seconds to days as that is not always a simple calculation.
public struct TimelessDate: Comparable, Equatable, Hashable {
    private(set) var date: Date
    private var calendar = Calendar.current

    // codebeat:disable[TOO_MANY_FUNCTIONS]

    /**
     Returns the DateInterval between the TimelessDate and 1 January 2001.
     
     This property's value is negative if the TimelessDate is earlier than the system's absolute reference date (1 January 2001).
     */
    public var dateIntervalSinceReferenceDate: DateInterval {
        return dateIntervalSince(TimelessDate(date: Date(timeIntervalSinceReferenceDate: 0)))
    }
    
    /**
     The DateInterval between the TimelessDate and the current TimelessDate.
     
     If the TimelessDate is earlier than the current TimelessDate, this property's value is negative.
     */
    public var dateIntervalSinceNow: DateInterval {
        return dateIntervalSince(TimelessDate(date: Date(timeIntervalSinceNow: 0)))
    }
    
    /**
     The DateInterval between the TimelessDate and 1 January 1970.
     
     This property's value is negative if the TimelessDate is earlier than 1 January 1970.
     */
    public var dateIntervalSince1970: DateInterval {
        return dateIntervalSince(TimelessDate(date: Date(timeIntervalSince1970: 0)))
    }
    
    /// Creates a `TimelessDate` initialized to the current date
    public init() {
        self.init(date: Date())
    }
    
    /**
     Creates a `TimelessDate` initialized relative to 1 January 2001 by a given number of days.
     
     - Parameter dateInterval: The number of days away from 1 January 2001
     */
    public init(dateIntervalSinceReferenceDate dateInterval: DateInterval) {
        self.init(dateInterval: dateInterval, since: Date(timeIntervalSinceReferenceDate: 0))
    }
    
    /**
     Creates a `TimelessDate` initialized relative to the current date by a given number of days.
     
     - Parameter dateIntervalSinceNow: The number of days away from today
     */
    public init(dateIntervalSinceNow: DateInterval) {
        self.init(dateInterval: dateIntervalSinceNow, since: Date())
    }
    
    /**
     Creates a `TimelessDate` initialized relative to 1 January 1970 by a given number of days.
     
     - Parameter dateIntervalSince1970: The number of days away from 1 January 1970
     */
    public init(dateIntervalSince1970: DateInterval) {
        self.init(dateInterval: dateIntervalSince1970, since: Date(timeIntervalSince1970: 0))
    }
    
    /**
     Creates a `TimelessDate` initialized relative to another given date by a given number of days.
     
     - Parameter dateInterval: The number of days to add to `timelessDate`. A negative value means the receiver will be earlier than `timelessDate`.
     - Parameter timelessDate: The reference TimelessDate.
     */
    public init(dateInterval: DateInterval, since timelessDate: TimelessDate) {
        self.init(dateInterval: dateInterval, since: timelessDate.date)
    }
    
    /**
     Creates a `TimelessDate` initialized relative to another given date by a given number of days.
     
     - Parameter dateInterval: The number of days to add to `timelessDate`. A negative value means the receiver will be earlier than `timelessDate`.
     - Parameter date: The reference Date.
     */
    public init(dateInterval: DateInterval, since date: Date) {
        self.date = Date(days: dateInterval, since: date) ?? date
    }
    
    /**
     Creates a `TimelessDate` initialized to the given `Date`
     
     - Parameter date: The date being converted into a `TimelessDate`
     */
    public init(date: Date) {
        self.init(dateInterval: 0, since: date)
    }
    
    /**
     Creates the DateInterval between the receiver and another given TimelessDate.
     
     - Parameter another: The TilessDate with which to compare the receiver.
     - Returns: The DateInterval between the receiver and `timelessDate` parameter. If the receiver is earlier than `timelessDate`, the return value is negative. If `timelessDate` is `nil`, the results are undefined.
     */
    public func dateIntervalSince(_ timelessDate: TimelessDate) -> DateInterval {
        guard let days = calendar.days(from: timelessDate.date, to: date) else { fatalError() }
        return days
    }
    
    /**
     Returns a new `TimelessDate` by adding a `DateInterval` to this `TimelessDate`.
     
     - Parameter dateInterval: The value to add, in days.
     - Returns: The timeless date offset by the `DateInterval`
     */
    public func adding(_ dateInterval: DateInterval) -> TimelessDate {
        return self + dateInterval
    }
    
    /**
     Add a `DateInterval` to this `TimelessDate`.
     
     - Parameter dateInterval: The value to add, in days.
     */
    public mutating func add(_ dateInterval: DateInterval) {
        self += dateInterval
    }
    
    // MARK: Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(date.hashValue)
    }
    
    // MARK: Math
    public static func +(lhs: TimelessDate, rhs: DateInterval) -> TimelessDate {
        return TimelessDate(dateIntervalSinceReferenceDate: lhs.dateIntervalSinceReferenceDate + rhs)
    }
    
    public static func -(lhs: TimelessDate, rhs: DateInterval) -> TimelessDate {
        return TimelessDate(dateIntervalSinceReferenceDate: lhs.dateIntervalSinceReferenceDate - rhs)
    }
    
    public static func +=(lhs: inout TimelessDate, rhs: DateInterval) {
        lhs = lhs + rhs
    }
    
    public static func -=(lhs: inout TimelessDate, rhs: DateInterval) {
        lhs = lhs - rhs
    }
    
    // MARK: Comparable
    public static func <(lhs: TimelessDate, rhs: TimelessDate) -> Bool {
        return lhs.dateIntervalSinceReferenceDate < rhs.dateIntervalSinceReferenceDate
    }
    
    public static func <=(lhs: TimelessDate, rhs: TimelessDate) -> Bool {
        return lhs.dateIntervalSinceReferenceDate <= rhs.dateIntervalSinceReferenceDate
    }

    public static func >=(lhs: TimelessDate, rhs: TimelessDate) -> Bool {
        return lhs.dateIntervalSinceReferenceDate >= rhs.dateIntervalSinceReferenceDate
    }

    public static func >(lhs: TimelessDate, rhs: TimelessDate) -> Bool {
        return lhs.dateIntervalSinceReferenceDate > rhs.dateIntervalSinceReferenceDate
    }
    
    // MARK: Equatable
    public static func ==(lhs: TimelessDate, rhs: TimelessDate) -> Bool {
        return lhs.dateIntervalSinceReferenceDate == rhs.dateIntervalSinceReferenceDate
    }
    // codebeat:enable[TOO_MANY_FUNCTIONS]
}

// MARK: CustomStringConvertable
extension TimelessDate: CustomDebugStringConvertible, CustomStringConvertible, CustomReflectable {
    
    public var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    public var debugDescription: String {
        return description
    }
    
    public var customMirror: Mirror {
        let c: [(label: String?, value: Any)] = [
            ("dateIntervalSinceReferenceDate", dateIntervalSinceReferenceDate)
        ]
        
        return Mirror(self, children: c, displayStyle: Mirror.DisplayStyle.struct)
    }
}
