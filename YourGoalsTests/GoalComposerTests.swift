//
//  GoalComposerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class GoalComposerTests: StorageTestCase {
    
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
    
    func testAddTaskToExistingOnes() {
        //  seutp
        let composer = GoalComposer(manager: self.manager)
        let goal = super.testDataCreator.createGoal(name: "Test Goal")
        let _ = try! composer.add(taskInfo: try! TaskInfo(taskName: "Task 1"), toGoal: goal)
        let _ = try! composer.add(taskInfo: try! TaskInfo(taskName: "Task 2"), toGoal: goal)
        let updatedGoal = try! composer.add(taskInfo: try! TaskInfo(taskName: "Task 3"), toGoal: goal)
        
        // act
        
        
        // test
        XCTAssertEqual(3, updatedGoal.allTasks().count)
        let task3 = updatedGoal.allTasks()[0]
        XCTAssertEqual(0, task3.prio)
        XCTAssertEqual("Task 3", task3.name)
    }
}
