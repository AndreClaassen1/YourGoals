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
}
