//
//  DateRangeTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 17.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class DateRangeTests: XCTestCase {
   
    func testDateRangeWithStartAndEndDate() {
        // setup
        let startDate =  Date.dateWithYear(2017, month: 12, day: 17)
        let endDate = Date.dateWithYear(2017, month: 12, day: 23)
        
        // act
        let dateRange = Calendar.current.dateRange(startDate: startDate, endDate: endDate)
        let dates = Array(dateRange)
        
        // test
        XCTAssertEqual(7, dates.count)
    }
    
    func testDateRangeWithStartAndNumberOfDays() {
        // setup
        let startDate =  Date.dateWithYear(2017, month: 12, day: 17)
        let numberOfDays = 7
        
        // act
        let dateRange = Calendar.current.dateRange(startDate: startDate, steps: numberOfDays - 1)!
        let dates = Array(dateRange)
        
        // test
        XCTAssertEqual(numberOfDays, dates.count)
    }
}
