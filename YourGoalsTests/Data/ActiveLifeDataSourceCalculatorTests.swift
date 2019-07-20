//
//  ActiveLifeDataSourceCalculatorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.07.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class ActiveLifeDataSourceCalculatorTests: StorageTestCase {

    let testDate = Date.dateWithYear(2017, month: 07, day: 02)
    
    func createTaskWithProgress(_ progress:[(start:String, end:String)]) -> Actionable {
        let goal = self.testDataCreator.createGoal(name: "Test Goal with progress")
        let task = self.testDataCreator.createTask(name: "Task with Progress", forGoal: goal)
        for values in progress {
            self.testDataCreator.createProgress(forTask: task, forDay: testDate, startTime: values.start, endTime: values.end)
        }
        return task
    }
    
    /// check a time info against a tuple with values in a human readable string format
    ///
    /// - Parameters:
    ///   - timeInfos: the time info
    ///   - expected: the expected values
    func checkTimeInfos(_ timeInfos:[ActionableTimeInfo], _ expected: [(start:String, end:String, length:String)]) {
        for tuple in timeInfos.enumerated() {
            let timeInfo = tuple.element
            let expectedValues = expected[tuple.offset]
            let expectedLength = Double(expectedValues.length)! * 60.0
            XCTAssertEqual(timeInfo.startingTime.formattedTime(locale: Locale(identifier: "de-DE")), expectedValues.start)
            XCTAssertEqual(timeInfo.endingTime.formattedTime(locale: Locale(identifier: "de-DE")), expectedValues.end)
            XCTAssertEqual(timeInfo.estimatedLength, expectedLength)
        }
    }
    
    func testProgressFromActionable() {
        // setup
        let actionable = createTaskWithProgress([
            ("08:00", "09:00"),
            ("11:00", "13:00")])
        
        // act
        let timeInfos = actionable.timeInfosFromDoneProgress(forDay: testDate)
        
        // test
        checkTimeInfos(timeInfos, [
            ("08:00", "09:00", "60"),
            ("11:00", "13:00", "120")])
    }

    func testProgressFromActionableSorted() {
        // setup
        let actionable = createTaskWithProgress([
            ("11:00", "13:00"),
            ("08:00", "09:00")
            ])
        
        // act
        let timeInfos = actionable.timeInfosFromDoneProgress(forDay: testDate)
        
        // test
        checkTimeInfos(timeInfos, [
            ("08:00", "09:00", "60"),
            ("11:00", "13:00", "120")])
    }
}
