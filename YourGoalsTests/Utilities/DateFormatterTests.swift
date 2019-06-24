//
//  DateFormatterTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 23.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class DateFormatterTests: XCTestCase {

    func testTimeFromString() {
        // setup
        
        // act
        let time = DateFormatter.timeFromShortTimeFormatted(timeStr: "08:15", locale: Locale(identifier: "de-DE"))
        
        // test
        XCTAssertEqual(Date.timeWith(hour: 08, minute: 15, second: 00), time)
    }
}
