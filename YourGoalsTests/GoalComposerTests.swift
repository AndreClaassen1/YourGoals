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
    
}
