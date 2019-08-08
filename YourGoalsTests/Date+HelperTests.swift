//
//  Date+HelperTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 06.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class Date_HelperTests: XCTestCase {
    
    func testDateInMinutes() {
        // setup
        let date = Date.timeFromMinutes(145)
        
        // act
        let minutes = date.timeInMinutes()
        
        // test
        XCTAssertEqual(145, minutes)
    }
    
    func testWeekdayAsChar() {
        // setup
        let testDate = Date.dateWithYear(2019, month: 08, day: 06) // its a tuesday
        
        // act
        let weekDayChar = testDate.weekdayChar
        
        // test
        XCTAssertEqual("T", weekDayChar, "It should be a a T for Tuesday")
    }
    
    func testStartOfWeek() {
        // setup
        let testDate = Date.dateWithYear(2019, month: 08, day: 07) // its a wednesday
        
        // act
        let startOfWeek = testDate.startOfWeek
        
        // test
        XCTAssertEqual(Date.dateWithYear(2019, month: 08, day: 05), startOfWeek)
    }
    
}
