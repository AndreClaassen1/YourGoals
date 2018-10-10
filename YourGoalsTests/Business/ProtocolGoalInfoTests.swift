//
//  ProtocolGoalInfoTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 10.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
import CoreData
@testable import YourGoals

class ProtocolGoalInfoTests: StorageTestCase {

    fileprivate func createProgressForTask(goal: Goal, taskIndex: Int, referenceDate: Date, fromHour: Int, tilHour: Int) {
        let task = goal.allTasks()[taskIndex]
        self.testDataCreator.createProgress(forTask: task, start: referenceDate.addMinutesToDate(6*60), end: referenceDate.addMinutesToDate(7*60))
    }
    
    func testWorkedTime() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 10, day: 10)
        let goal = self.testDataCreator.createGoalWithTasks(infos: [
            (name: "Task 1", prio: 1, size: 20.0, commitmentDate: referenceDate), // 20 minutes and yet in the abstract today task
            (name: "Task 2", prio: 2, size: 40.0, commitmentDate: referenceDate)  // 40 minutes
            ])
        
        // create progress with exact 2 hours
        createProgressForTask(goal: goal, taskIndex: 0, referenceDate: referenceDate, fromHour: 7, tilHour: 8)
        createProgressForTask(goal: goal, taskIndex: 1, referenceDate: referenceDate, fromHour: 9, tilHour: 10)
        let goalInfo = ProtocolGoalInfo(goal: goal, date: referenceDate)
        
        // act
        let workedOnGoalTimeInterval = try! goalInfo.workedOnGoal(manager: self.manager, backburnedGoals: false)
        
        // test
        XCTAssertEqual(TimeInterval(2.0 * 60.0 * 60.0), workedOnGoalTimeInterval)
    }
}
