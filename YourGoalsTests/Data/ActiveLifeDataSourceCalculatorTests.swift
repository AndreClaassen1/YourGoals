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
    
    func checkTimeInfos(_ timeInfos:[ActionableTimeInfo], _ expected: [(start:String, end:String)]) {
        for tuple in timeInfos.enumerated() {
            let timeInfo = tuple.element
            let expectedValues = expected[tuple.offset]
            XCTAssertEqual(timeInfo.startingTime.formattedTime(locale: Locale(identifier: "de-DE")), expectedValues.start)
            XCTAssertEqual(timeInfo.endingTime.formattedTime(locale: Locale(identifier: "de-DE")), expectedValues.end)
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
            ("08:00", "09:00"),
            ("11:00", "13:00")])
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
            ("08:00", "09:00"),
            ("11:00", "13:00")])
    }
}
