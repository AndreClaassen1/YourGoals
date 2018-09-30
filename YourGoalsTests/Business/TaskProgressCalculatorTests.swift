//
//  TaskProgressCalculatorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 27.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
import CoreData
@testable import YourGoals

class TaskProgressCalculatorTests: StorageTestCase {
    
    func testCalculateProgressOnGoal() {
        let referenceDateStart = Date.dateTimeWithYear(2018, month: 09, day: 27, hour: 12, minute: 00, second: 00)
        let referenceDateCurrent = referenceDateStart.addMinutesToDate(20)
        
        // setup 3 tasks with 100 Minutes total size
        let goal = self.testDataCreator.createGoalWithTasks(infos: [
            (name: "Task 1", prio: 1, size: 40.0, commitmentDate: nil), // 40 minutes
            (name: "Task 2", prio: 2, size: 20.0, commitmentDate: nil), // 20 minutes
            (name: "Task 3", prio: 3, size: 40.0, commitmentDate: nil)  // 40 minutes
            ] )
        
        // fetch the first task in progress and work on it 20 Minutes eg. 30% on the task
        let taskInProgress = goal.allTasks().filter({$0.name == "Task 1" }).first!
        let progress = self.testDataCreator.createProgress(forTask: taskInProgress, start: referenceDateStart, end: referenceDateCurrent)
        
        // act
        let percentage = TaskProgressCalculator().calculateProgressOnGoal(taskProgress: progress, forDate: referenceDateCurrent)
        
        // test
        XCTAssertEqual(0.2, percentage, "the percentage should be 20% which corresponds with 20 out 100 Minutes")
    }
}
