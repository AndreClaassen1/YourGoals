//
//  TaskOrderManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TaskOrderManagerTests: StorageTestCase {
    
    func testOrderedTask() {
        // setup
        let taskFactory = TaskFactory(manager: self.manager)
        let tasksUnsorted = [
            taskFactory.create(name: "Task 3", state: .active, prio: 3),
            taskFactory.create(name: "Task 1", state: .active, prio: 1),
            taskFactory.create(name: "Task 2", state: .active, prio: 2) ]
        
        let goalFactory = GoalFactory(manager: self.manager)
        let goal = try! goalFactory.create(name: "New Goal", prio: 1, reason: "unit test", startDate: Date.dateWithYear(2017, month: 10, day: 30), targetDate: Date.dateWithYear(2017, month: 11, day: 01), image: nil)
        goal.addToTasks(tasksUnsorted)
        
        try! self.manager.dataManager.saveContext()
    
        // act
        let taskOrderManager = TaskOrderManager(manager: self.manager)
        let tasksByOrder = try! taskOrderManager.tasksByOrder(forGoal: goal)
        
        // test
        XCTAssertEqual(3, tasksByOrder.count)
        XCTAssertEqual(1, tasksByOrder[0].prio)
        XCTAssertEqual(2, tasksByOrder[1].prio)
        XCTAssertEqual(3, tasksByOrder[2].prio)

    }
    
}
