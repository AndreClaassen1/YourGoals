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
        let numberOfGeneratedDates = 10
        let addtionalCommitDates = 3 // included Date from 2017, Free Select of commit date and no commit date
        
        // act
        let tuples = creator.selectableCommitDates(startingWith: Date(), numberOfDays: numberOfGeneratedDates, includingDate: Date.dateWithYear(2017, month: 11, day: 30 ))
        
        // test
        XCTAssertEqual(numberOfGeneratedDates + addtionalCommitDates, tuples.count, "10 dates plus nil date plus not included date")
        XCTAssertEqual("No commit date", tuples[0].text)
        XCTAssertEqualLocalized("en", "November 30, 2017", tuples[1].text)
        XCTAssertEqualLocalized("de-DE", "30. November 2017", tuples[1].text)
        XCTAssertEqual("Today", tuples[2].text)
        XCTAssertEqual("Tomorrow", tuples[3].text)
    }
}
