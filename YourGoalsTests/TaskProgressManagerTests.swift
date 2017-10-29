//
//  TaskProgressManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

/// test case for the task progress manager.
class TaskProgressManagerTests: StorageTestCase {

    /// the test object.
    var progressManager:TaskProgressManager!
    
    override func setUp() {
        super.setUp()
        self.progressManager = TaskProgressManager(manager: self.manager)
    }
    
    /// test for starting a progress on a given task
    func testStartProgress() {
        // setup
        let task = TaskFactory(manager: self.manager).create(name: "Task with started progress", state: .active)
        
        // act
        let progressStartDate = Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 12, minute: 0, second: 0)
        try! progressManager.startProgress(forTask: task, atDate: progressStartDate)
        
        // test
        let progress = task.progressFor(date: Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 13, minute: 0, second: 0))
        XCTAssertNotNil(progress)
        XCTAssertEqual(progressStartDate, progress?.start)
        XCTAssertNil(progress?.end)
    }
    
    /// test for stopping progress on a given task
    func testStoppedProgress() {
        // setup
        let task = TaskFactory(manager: self.manager).create(name: "Task with stopped progress", state: .active)
        
        // act
        let progressStartDate = Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 12, minute: 0, second: 0)
        try! progressManager.startProgress(forTask: task, atDate: progressStartDate)

        let progressEndDate =  Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 14, minute: 0, second: 0)
        try! progressManager.stopProgress(forTask: task, atDate: progressEndDate)

        // test
        let progress = task.progressFor(date: Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 13, minute: 0, second: 0))
        XCTAssertNotNil(progress)
    }
    
    /// restart progress on a given task
    func testRestartProgress() {
        // setup
        let task = TaskFactory(manager: self.manager).create(name: "Task with restarted progress", state: .active)
        
        // act
        let progressStartDate = Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 12, minute: 0, second: 0)
        try! progressManager.startProgress(forTask: task, atDate: progressStartDate)
        
        let progressEndDate =  Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 15, minute: 0, second: 0)
        try! progressManager.stopProgress(forTask: task, atDate: progressEndDate)

        let progressRestartDate = Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 13, minute: 30, second: 0)
        try! progressManager.startProgress(forTask: task, atDate: progressRestartDate)

        
        // test
        XCTAssertEqual(2, task.allProgress().count)
        
        let progress1 = task.progressFor(date: Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 13, minute: 0, second: 0))
        XCTAssertEqual(progressStartDate, progress1?.start)
        XCTAssertEqual(progressRestartDate, progress1?.end)

        let progress2 = task.progressFor(date: Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 14, minute: 0, second: 0))
        XCTAssertEqual(progressRestartDate, progress2?.start)
        XCTAssertEqual(nil, progress2?.end)
    }
    
    /// tests the number of progress function. in reality this number should be 0 or 1 because
    /// there couldn't be more than one task with a progress
    func testNumberOfProgressEqual1() {
        // setup
        let tasks = TaskFactory(manager: self.manager).createTasks(numberOfTasks: 3, state: .active)
        let progressStartDate = Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 12, minute: 0, second: 0)
        try! progressManager.startProgress(forTask: tasks[0], atDate: progressStartDate)

        // act
        let numberOfProgress = try! progressManager.numberOfTasksWithProgress()
        
        // test
        XCTAssertEqual(1, numberOfProgress)
        
    }
  
    /// there couldn't be more than one task with a progress
    func testNumberOfProgressEqual0() {
        // act
        let numberOfProgress = try! progressManager.numberOfTasksWithProgress()
        
        // test
        XCTAssertEqual(0, numberOfProgress)
    }
    
    /// tests the number of progress function. in reality this number should be 0 or 1 because
    /// there couldn't be more than one task with a progress
    func testNumberOfProgressWithMany() {
        // setup
        let tasks = TaskFactory(manager: self.manager).createTasks(numberOfTasks: 3, state: .active)
        let progressStartDate = Date.dateTimeWithYear(2017, month: 10, day: 25, hour: 12, minute: 0, second: 0)
        
        // start each task
        tasks.forEach{ try! progressManager.startProgress(forTask: $0, atDate: progressStartDate) }
        
        // act
        let numberOfProgress = try! progressManager.numberOfTasksWithProgress()
        
        // test
        XCTAssertEqual(1, numberOfProgress)
    }
}

