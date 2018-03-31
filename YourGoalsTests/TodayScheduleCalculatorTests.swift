//
//  TodayScheduleCalculatorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 11.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TodayScheduleCalculatorTests: StorageTestCase {
  
    /// calculate a list of starting times
    func testCalulateStartingTimesWithoutActiveTask() {
        // setup
        let commitmentDate = Date.dateWithYear(2018, month: 01, day: 11)
        let testDateTime = Date.dateTimeWithYear(2018, month: 01, day: 11, hour: 13, minute: 00, second: 00)
        let goal = super.testDataCreator.createGoalWithTasks(infos: [
            ("Task 30 Minutes", 1, 30.0, commitmentDate),
            ("Task 90 Minutes", 2, 90.0, commitmentDate)
            ])
        let actionables = goal.allTasks()
        
        // act
        let scheduleCalculator = TodayScheduleCalculator(manager: self.manager)
        let times = try! scheduleCalculator.calculateStartingTimes(forTime: testDateTime, actionables: actionables)
        
        // test
        XCTAssertEqual(2, times.count)
        XCTAssertEqual(Date.dateTimeWithYear(2018, month: 01, day: 11, hour: 13, minute: 00, second: 00), times[0])
        XCTAssertEqual(Date.dateTimeWithYear(2018, month: 01, day: 11, hour: 13, minute: 30, second: 00), times[1])
    }
    
    /// calculate a list of starting times
    func testCalulateStartingTimesWithActiveTask() {
        // setup
        let commitmentDate = Date.dateWithYear(2018, month: 01, day: 11)
        let testDateTime = Date.dateTimeWithYear(2018, month: 01, day: 11, hour: 13, minute: 00, second: 00)
        let goal = super.testDataCreator.createGoalWithTasks(infos: [
            ("Task 30 Minutes which is active", 1, 30.0, commitmentDate),
            ("Task 90 Minutes", 2, 90.0, commitmentDate)
            ])
        let actionables = goal.allTasks()
        let activeTask = actionables.first!
       
        // task is progressing since 15 Minutes
        try! TaskProgressManager(manager: self.manager).startProgress(forTask: activeTask, atDate: testDateTime.addingTimeInterval(60.0 * 15.0))
        
        // act
        let scheduleCalculator = TodayScheduleCalculator(manager: self.manager)
        let times = try! scheduleCalculator.calculateStartingTimes(forTime: testDateTime, actionables: actionables)
        
        // test
        XCTAssertEqual(2, times.count)
        XCTAssertEqual(Date.dateTimeWithYear(2018, month: 01, day: 11, hour: 13, minute: 00, second: 00), times[0])
        XCTAssertEqual(Date.dateTimeWithYear(2018, month: 01, day: 11, hour: 13, minute: 30, second: 00), times[1])
    }
}
