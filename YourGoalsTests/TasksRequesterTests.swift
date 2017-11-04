//
//  TasksRequesterTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 04.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TasksRequesterTests: StorageTestCase {

    func createTestDataWithTaskInProgress() -> Task {
        let tasks = TaskFactory(manager: self.manager).createTasks(numberOfTasks: 3, state: .active)
        return tasks[0]
    }
    
    func testActiveTasksButNotComitted() {
        // setup
        let date = Date.dateWithYear(2017, month: 11, day: 02)
        let taskInProgress = createTestDataWithTaskInProgress()
        
        // start the first task, but this task is not committed
        try! TaskProgressManager(manager: self.manager).startProgress(forTask: taskInProgress, atDate: date)
        
        
        // act
        let activeTasksButNotCommitted = try! TasksRequester(manager: self.manager).areThereActiveTasksWhichAreNotCommitted(forDate: date)
        
        // test
        XCTAssertTrue(activeTasksButNotCommitted)
    }
    
    func testActiveTasksButComitted() {
        // setup
        let date = Date.dateWithYear(2017, month: 11, day: 02)
        let taskInProgress = createTestDataWithTaskInProgress()
        
        // start the first task, but this task is not committed
        try! TaskProgressManager(manager: self.manager).startProgress(forTask: taskInProgress, atDate: date)
        try! TaskCommitmentManager(manager: self.manager).commit(task: taskInProgress, forDate: date)
        
        // act
        let activeTasksButNotCommitted = try! TasksRequester(manager: self.manager).areThereActiveTasksWhichAreNotCommitted(forDate: date)
        
        // test
        XCTAssertFalse(activeTasksButNotCommitted)
    }
}
