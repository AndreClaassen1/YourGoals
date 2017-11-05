//
//  GoalComposerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

/// tests the goal composer
class GoalComposerTests: StorageTestCase {
    
    /// test adding a new task for a goal
    func testAddTask() {
        // setup
        let composer = GoalComposer(manager: self.manager)
        let goal = super.testDataCreator.createGoal(name: "Test Goal")
        
        // act
        let updatedGoal = try! composer.add(taskInfo: try! TaskInfo(taskName: "Test task"), toGoal: goal)
        
        // test
        XCTAssertEqual(1, updatedGoal.allTasks().count)
        let newTask = updatedGoal.allTasks()[0]
        XCTAssertEqual(0, newTask.prio)
    }
    
    /// test adding a new task to an existing goal
    func testAddTaskToExistingOnes() {
        //  seutp
        let composer = GoalComposer(manager: self.manager)
        let goal = super.testDataCreator.createGoal(name: "Test Goal")
        let _ = try! composer.add(taskInfo: try! TaskInfo(taskName: "Task 1"), toGoal: goal)
        let _ = try! composer.add(taskInfo: try! TaskInfo(taskName: "Task 2"), toGoal: goal)
        let _ = try! composer.add(taskInfo: try! TaskInfo(taskName: "Task 3"), toGoal: goal)
        
        // test - the latest task should be at the top position
        let tasksByOrder = try! TaskOrderManager(manager: self.manager).tasksByOrder(forGoal: goal)
        XCTAssertEqual(3, tasksByOrder.count)
        let task3 = tasksByOrder[0]
        XCTAssertEqual(0, task3.prio)
        XCTAssertEqual("Task 3", task3.name)
    }
}
