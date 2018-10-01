//
//  TaskOrderManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

/// tests for the TaskOrderManager class
class TaskOrderManagerTests: StorageTestCase {
    
    func createGoalWithTasks(infos: [(name: String, prio:Int )]) -> Goal {
        let taskFactory = TaskFactory(manager: self.manager)
        let tasksUnsorted = infos.map{
            taskFactory.create(name: $0.name, state: .active, prio: Int16($0.prio))
        }
    
        
        let goalFactory = GoalFactory(manager: self.manager)
        let goal = try! goalFactory.create(name: "New Unit-Test Goal", prio: 1, reason: "unit test", startDate: Date.dateWithYear(2017, month: 10, day: 30), targetDate: Date.dateWithYear(2017, month: 11, day: 01), image: nil, backburnedGoals: false)
        goal.addToTasks(tasksUnsorted)
        try! self.manager.dataManager.saveContext()
        return goal
    }
    
    
    /// test othe tasksByOrder funcitoin
    func testOrderedTask() {
        // setup
        let goal = createGoalWithTasks(infos: [
            (name: "Task 3", prio: 3),
            (name: "Task 1", prio: 1),
            (name: "Task 2", prio: 2) ])
        
        // act
        let taskOrderManager = TaskOrderManager(manager: self.manager)
        let tasksByOrder = try! taskOrderManager.tasksByOrder(forGoal: goal)
        
        // test
        XCTAssertEqual(3, tasksByOrder.count)
        XCTAssertEqual(1, tasksByOrder[0].prio)
        XCTAssertEqual(2, tasksByOrder[1].prio)
        XCTAssertEqual(3, tasksByOrder[2].prio)
    }
    
    /// test updating the order of the tasks
    func testUpdateOrder() {
        
    }
    
}
