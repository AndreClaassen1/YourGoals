//
//  TaskCommitmentTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TaskCommitmentTests: StorageTestCase {
    
    func testNotCommitment() {
        // setup
        let testDate = Date.dateWithYear(2017, month: 11, day: 1)
        let factory = TaskFactory(manager: self.manager)
        let task = factory.create(name: "Task", state: .active, prio: 1)
        
        // act
        
        
        // done
        XCTAssertEqual(CommittingState.notCommitted, task.committingState(forDate: testDate))
    }
    
    func testCommitmentForDate() {
        // setup
        let testDate = Date.dateWithYear(2017, month: 11, day: 1)
        let factory = TaskFactory(manager: self.manager)
        let task = factory.create(name: "Task", state: .active, prio: 1)
        
        // act
        let commitmentManager = TaskCommitmentManager(manager: self.manager)
        try! commitmentManager.commit(task: task, forDate: testDate)
        
        // done
        let committedTasks = try! commitmentManager.committedTasks(forDate: testDate)
        XCTAssertEqual(1, committedTasks.count)
        XCTAssertEqual(CommittingState.committedForDate, committedTasks[0].committingState(forDate: testDate))
    }
    
    func testCommitmentForPast() {
        // setup
        let testDate = Date.dateWithYear(2017, month: 11, day: 08)
        let factory = TaskFactory(manager: self.manager)
        let tasks = factory.createTasks(numberOfTasks: 3, state: .active)
        
        // shift 2 from 3 tasks in the past
        tasks[0].commitmentDate = testDate.addDaysToDate(-1)
        tasks[1].commitmentDate = testDate.addDaysToDate(-2)
        try! self.manager.saveContext()
        
        // act
        let commitmentManager = TaskCommitmentManager(manager: self.manager)
        let committedTasksFromThePast = try! commitmentManager.committedTasksPast(forDate: testDate)
        
        // test
        XCTAssertEqual(2, committedTasksFromThePast.count)
    }
    
}
