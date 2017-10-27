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
}
