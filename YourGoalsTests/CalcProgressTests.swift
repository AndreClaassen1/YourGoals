//
//  CalcProgressTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class CalcProgressTests: StorageTestCase {
    
    func createTaskWithProgress(name: String, sizeInMinutes: Float, startProgressDate date: Date) -> Task {
        let goal = self.testDataCreator.createGoal(name: "Progress Goal")
        let task = self.testDataCreator.createTask(name: name, withSize: sizeInMinutes, forGoal: goal)
        self.testDataCreator.startProgress(forTask: task, atDate: date)
        return task
    }
    

    func testCalcProgress() {
        // setup
        let progressStartTime = Date.dateTimeWithYear(2018, month: 01, day: 02, hour: 12, minute: 00, second: 00)
        
        // test progress 30 minutes later
        let progressTestTime = Date.dateTimeWithYear(2018, month: 01, day: 02, hour: 12, minute: 30, second: 00)
        let task = createTaskWithProgress(name: "testCalcProgress", sizeInMinutes: 30.0, startProgressDate: progressStartTime)
        
        // act
        let progression = task.calcProgressDuration(atDate: progressTestTime)!
        
        // test
        XCTAssertEqual(progression / 60.0, 30.0, "The progression time should be exact 30 minutes")
    }
    
    func testRemainingTime() {
        // setup
        let progressStartTime = Date.dateTimeWithYear(2018, month: 01, day: 02, hour: 12, minute: 00, second: 00)
        
        // test progress 15 minutes later
        let progressTestTime = Date.dateTimeWithYear(2018, month: 01, day: 02, hour: 12, minute: 15, second: 00)
        let task = createTaskWithProgress(name: "testCalcProgress", sizeInMinutes: 30.0, startProgressDate: progressStartTime)

        // act
        let remainingTime = task.calcRemainingTimeInterval(atDate: progressTestTime)
        
        // test
        XCTAssertEqual(remainingTime   / 60.0, 15.0, "After 15 minutes progress the remaining time should be 15 minutes")
    }
    
    
    func testRemainingPercentage() {
        // setup
        let progressStartTime = Date.dateTimeWithYear(2018, month: 01, day: 02, hour: 12, minute: 00, second: 00)
        
        // test progress 15 minutes later
        let progressTestTime = Date.dateTimeWithYear(2018, month: 01, day: 02, hour: 12, minute: 15, second: 00)
        let task = createTaskWithProgress(name: "testCalcProgress", sizeInMinutes: 30.0, startProgressDate: progressStartTime)
        
        // act
        let remainingPercentage = task.calcRemainingPercentage(atDate: progressTestTime)
        
        // test
        XCTAssertEqual(0.5, remainingPercentage, "After 15 minutes progress the remaining percentage should be 50%")
    }
}
