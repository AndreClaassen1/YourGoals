//
//  TaskProgressManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TaskProgressManagerTests: StorageTestCase {

    var progressManager:TaskProgressManager!
    
    override func setUp() {
        super.setUp()
        self.progressManager = TaskProgressManager(manager: self.manager)
    }
    
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
    
    
    
    
    
}
