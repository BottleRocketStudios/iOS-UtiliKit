//
//  DateTests.swift
//  UtiliKit
//
//  Copyright © 2017 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import UtiliKit

class DateTests: XCTestCase {
    var today: Date!
    let dateFormatter = DateFormatter()
    static let secondsPerDay: Double = 86400
    static let secondsPerHour: Double = 3600
    static let secondsPerMinute: Double = 60
    var timelessTomorrow: TimelessDate = TimelessDate(dateIntervalSinceNow: 1)
    
    override func setUp() {
        super.setUp()
        today = Date()
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
    }
    
    override func tearDown() {
        today = nil
        
        super.tearDown()
    }
    
    //MARK: - Date tests
    func test_DateInitialization_DaysCorrect() {
        let tomorrow = Date(days: 1, since: today)
        let alsoTomorrow = Date(timeInterval: DateTests.secondsPerDay, since: today)

        XCTAssertEqual(dateFormatter.string(from: tomorrow!), dateFormatter.string(from: alsoTomorrow))
    }

    func test_DateInitialization_HoursCorrect() {
        let anHour = Date(hours: 1, since: today)
        let alsoAnHour = Date(timeInterval: DateTests.secondsPerHour, since: today)

        XCTAssertEqual(dateFormatter.string(from: anHour!), dateFormatter.string(from: alsoAnHour))
    }

    func test_DateInitialization_MinutesCorrect() {
        let aMinute = Date(minutes: 1, since: today)
        let alsoAMinute = Date(timeInterval: DateTests.secondsPerMinute, since: today)

        XCTAssertEqual(dateFormatter.string(from: aMinute!), dateFormatter.string(from: alsoAMinute))
    }

    func test_DateInitialization_SecondsCorrect() {
        let aSecond = Date(seconds: 1, since: today)
        let alsoASecond = Date(timeInterval: 1, since: today)

        XCTAssertEqual(dateFormatter.string(from: aSecond!), dateFormatter.string(from: alsoASecond))
    }

    func test_DateAddition_AddDaysCorrectly() {
        let tomorrow = today.adding(days: 1)
        let alsoTomorrow = Date(days: 1, since: today)

        XCTAssertEqual(dateFormatter.string(from: tomorrow!), dateFormatter.string(from: alsoTomorrow!))
    }

    func test_DateAddition_AddHoursCorrectly() {
        let anHour = today.adding(hours: 1)
        let alsoAnHour = Date(hours: 1, since: today)

        XCTAssertEqual(dateFormatter.string(from: anHour!), dateFormatter.string(from: alsoAnHour!))
    }

    func test_DateAddition_AddMinutesCorrectly() {
        let aMinute = today.adding(minutes: 1)
        let alsoAMinute = Date(minutes: 1, since: today)

        XCTAssertEqual(dateFormatter.string(from: aMinute!), dateFormatter.string(from: alsoAMinute!))
    }

    func test_DateAddition_AddSecondsCorrectly() {
        let aSecond = today.adding(seconds: 1)
        let alsoASecond = Date(timeInterval: 1, since: today)

        XCTAssertEqual(dateFormatter.string(from: aSecond!), dateFormatter.string(from: alsoASecond))
    }

    func test_DateSubtraction_SubtractDaysCorrectly() {
        let tomorrow = today.subtracting(days: 1)
        let alsoTomorrow = Date(days: -1, since: today)

        XCTAssertEqual(dateFormatter.string(from: tomorrow!), dateFormatter.string(from: alsoTomorrow!))
    }

    func test_DateSubtraction_SubtractHoursCorrectly() {
        let anHour = today.subtracting(hours: 1)
        let alsoAnHour = Date(hours: -1, since: today)

        XCTAssertEqual(dateFormatter.string(from: anHour!), dateFormatter.string(from: alsoAnHour!))
    }

    func test_DateSubtraction_SubtractMinutesCorrectly() {
        let aMinute = today.subtracting(minutes: 1)
        let alsoAMinute = Date(minutes: -1, since: today)

        XCTAssertEqual(dateFormatter.string(from: aMinute!), dateFormatter.string(from: alsoAMinute!))
    }
    
    func test_TimelessDate_Initialization() {
        XCTAssertEqual(TimelessDate(dateInterval: 0, since: timelessTomorrow.date), timelessTomorrow)
    }

    func test_TimelessDate_LessThan() {
        let today = TimelessDate()

        XCTAssertLessThan(today, timelessTomorrow)
    }

    func test_TimelessDate_GreaterThan() {
        let today = TimelessDate()

        XCTAssertGreaterThan(timelessTomorrow, today)
    }

    func test_TimelessDate_PlusEquals() {
        var tomorrow = TimelessDate(dateInterval: 0, since: TimelessDate())
        tomorrow += 1

        XCTAssertEqual(tomorrow, timelessTomorrow)
    }

    func test_TimelessDate_MinusEquals() {
        var tomorrow = TimelessDate() + 2
        tomorrow -= 1

        XCTAssertEqual(tomorrow, timelessTomorrow)
    }

    func test_TimelessDate_GreaterThanOrEqualGreaterWorks() {
        let today = TimelessDate()
        XCTAssertGreaterThanOrEqual(timelessTomorrow, today)
    }

    func test_TimelessDate_GreaterThanOrEqualEqualWorks() {
        XCTAssertGreaterThanOrEqual(timelessTomorrow, timelessTomorrow)
    }

    func test_TimelessDate_LessThanOrEqualLessThanWorks() {
        let today = TimelessDate()
        let tomorrow = today + 1

        XCTAssertLessThanOrEqual(tomorrow, tomorrow)
    }

    func test_TimelessDate_LessThanOrEqualEqualWorks() {
        let today = TimelessDate()
        let tomorrow = today + 1

        XCTAssertLessThanOrEqual(today, tomorrow)
    }

    func test_TimelessDate_AddingDays() {
        let today = TimelessDate()
        let tomorrow = today + 1
        XCTAssertEqual(tomorrow, today.addingDateInterval(1))
    }

    func test_TimelessDate_MutatingAddingDays() {
        var today = TimelessDate()
        let tomorrow = today + 1
        today.addDateInterval(1)
        XCTAssertEqual(tomorrow, today)
    }
    
    func test_TimelessDate_1970DateIntervalVariable() {
        let ref1970 = TimelessDate(dateIntervalSince1970: 3)
        XCTAssertEqual(3, ref1970.dateIntervalSince1970)
    }
    
    func test_TimelessDate_ReferenceDateIntervalVariable() {
        let ref = TimelessDate(dateIntervalSinceReferenceDate: 3)
        XCTAssertEqual(3, ref.dateIntervalSinceReferenceDate)
    }
    
    func test_TimelessDate_CurrentDateIntervalVariable() {
        let today = TimelessDate(dateIntervalSinceNow: 3)
        XCTAssertEqual(3, today.dateIntervalSinceNow)
    }
}
