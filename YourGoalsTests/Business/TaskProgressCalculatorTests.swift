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
            (name: "Task 1", prio: 1, size: 40.0, commitmentDate: nil, beginTime: nil, state: nil), // 40 minutes
            (name: "Task 2", prio: 2, size: 20.0, commitmentDate: nil, beginTime: nil, state: nil), // 20 minutes
            (name: "Task 3", prio: 3, size: 40.0, commitmentDate: nil, beginTime: nil, state: nil)  // 40 minutes
            ] )
        
        // fetch the first task in progress and work on it 20 Minutes eg. 30% on the task
        let taskInProgress = goal.allTasks().filter({$0.name == "Task 1" }).first!
        let progress = self.testDataCreator.createProgress(forTask: taskInProgress, start: referenceDateStart, end: referenceDateCurrent)
        
        // act
        let percentage = TaskProgressCalculator(manager: self.manager, backburnedGoals: false).calculateProgressOnGoal(taskProgress: progress, forDate: referenceDateCurrent)
        
        // test
        XCTAssertEqual(0.2, percentage, "the percentage should be 20% which corresponds with 20 out 100 Minutes")
    }
    
    func testCalculateProgressOnTodayGoal() {
        let referenceDateStart = Date.dateTimeWithYear(2018, month: 09, day: 27, hour: 12, minute: 00, second: 00)
        let referenceDateCurrent = referenceDateStart.addMinutesToDate(20)
        let today = referenceDateStart.day()
        let yesterday = today.addDaysToDate(-1)
        
        // setup 3 tasks with 100 Minutes total size
        
        let strategyManager = StrategyManager(manager: self.manager)
        let strategy = try! strategyManager.assertValidActiveStrategy()
        let todayGoal = try! strategyManager.assertTodayGoal(strategy: strategy)
    
        
        self.testDataCreator.createTasks(forGoal: todayGoal, infos: [
            (name: "Task 1", prio: 1, size: 20.0, commitmentDate: today, beginTime: nil, state: nil) // 40 minutes
            ] )
        
        let _ = self.testDataCreator.createGoalWithTasks(infos: [
            (name: "Task 2", prio: 2, size: 20.0, commitmentDate: yesterday, beginTime: nil, state: nil), // 20 minutes and yet in the abstract today task
            (name: "Task 3", prio: 3, size: 40.0, commitmentDate: nil, beginTime: nil, state: nil)  // 40 minutes
            ])

        
        // fetch the first task in progress and work on it 20 Minutes eg. 30% on the task
        let taskInProgress = todayGoal.allTasks().filter({$0.name == "Task 1" }).first!
        let progress = self.testDataCreator.createProgress(forTask: taskInProgress, start: referenceDateStart, end: referenceDateCurrent)
        
        // act
        let percentage = TaskProgressCalculator(manager: self.manager, backburnedGoals: false).calculateProgressOnGoal(taskProgress: progress, forDate: referenceDateCurrent)
        
        // test
        XCTAssertEqual(0.5, percentage, "the percentage should be 50% which corresponds to 20.0 minutes from Task 1 and 20.0 minutes from Task 2 against 40.0 minutes from Task3")
    }
    
    
    
}
