//
//  TaskWorktimeCalculatorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 06.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest

import XCTest
import CoreData
@testable import YourGoals

class TaskWorktimeCalculatorTests: StorageTestCase {

    let calculator = TaskWorktimeCalculator()
    
    func createProgress(task: Task, date: Date, fromHour: Int, tilHour: Int) {
        self.testDataCreator.createProgress(forTask: task, start: date.addMinutesToDate(60 * fromHour), end: date.addMinutesToDate(60 * tilHour))
    }
    
    
    func testCalculateWorktime() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 10, day: 06)
        let goal = self.testDataCreator.createGoal(name: "Test Goal")
        let task = self.testDataCreator.createTask(name: "Task with Progress", forGoal: goal)

        // create progress from 10:00 til 11:00 => 1 hour
        createProgress(task: task, date: referenceDate, fromHour: 10, tilHour: 11)
        // and from 13:00 til 15:00 => 2 Hours
        createProgress(task: task, date: referenceDate, fromHour: 13, tilHour: 15)
        let expectedTimeInterval =  TimeInterval(3.0 * 60.0 * 60.0)
        
        // act
        let worktimeInterval = calculator.calculateWorktime(task: task, date: referenceDate)
        
        // test
        XCTAssertEqual(expectedTimeInterval, worktimeInterval)
    }
}
