//
//  CalendarBarCellTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 07.08.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals


class CalendarBarCellTests: XCTestCase {

    /// when I set a calendar bar cell to 2019/08/07  the day name label should be a "W" for Wednesday and the label a "7" for the 7th.
    func testConfigureCell() {
        // setup
        let cell = CalendarBarCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let testDate = Date.dateWithYear(2019, month: 08, day: 07) // wednesday
        let progress = 0.5 // 50%
        
        // act
        cell.configure(value: CalendarBarCellValue(date: testDate, progress: progress))
        
        // test
        XCTAssertEqual(cell.dayNameLabel.text, "W")
        XCTAssertEqual(cell.dayNumberLabel.text, "7")
        XCTAssertEqual(cell.dayProgressRing.progress, CGFloat(progress))
    }
}
