//
//  CommitDateCreatorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 17.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class CommitDateCreatorTests: XCTestCase {
    
    func testCommitDates() {
        // setup
        let creator = SelectableCommitDatesCreator()
        
        // act
        let tuples = creator.selectableCommitDates(startingWith: Date(), numberOfDays: 10, includingDate: Date.dateWithYear(2017, month: 11, day: 30 ))
        
        // test
        XCTAssertEqual(10+2, tuples.count, "10 dates plus nil date plus not included date")
        XCTAssertEqual("No commit date", tuples[0].text)
        XCTAssertEqual("November 30, 2017", tuples[1].text)
        XCTAssertEqual("Today", tuples[2].text)
        XCTAssertEqual("Tomorrow", tuples[3].text)
    }
}
