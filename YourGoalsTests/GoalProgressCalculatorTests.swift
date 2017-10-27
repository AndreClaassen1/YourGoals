//
//  GoalProgressCalculatorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class GoalProgressCalculatorTests: StorageTestCase {
    
    
    func createTestGoal(startDate: Date, targetDate: Date, numberOfActiveTasks: Int, numberOfDoneTasks: Int) -> Goal {
        // setup
        let taskFactory = TaskFactory(manager: self.manager)
        let goalFactory = GoalFactory(manager: self.manager)
        let interval = targetDate.timeIntervalSince(startDate)
        let secondsPerDay = 3600.0 * 24.0
        let days = interval / secondsPerDay
        let goal = try! goalFactory.create(name: "Test goal for calculation", prio: 999, reason: "no reason", startDate: startDate, targetDate: targetDate, image: nil)
        let activeTasks = taskFactory.createTasks(numberOfTasks: numberOfActiveTasks, state: .active)
        goal.addToTasks(activeTasks)
        let doneTasks = taskFactory.createTasks(numberOfTasks: numberOfDoneTasks, state: .done  )
        goal.addToTasks(doneTasks)
        try! self.manager.dataManager.saveContext()
        return goal
    }
    
    func testCalculation() {
        // setup
        let startDate = Date.dateWithYear(2017, month: 01, day: 01)
        let targetDate = Date.dateWithYear(2017, month: 03, day: 31)
        let testDate = Date.dateWithYear(2017, month: 02, day: 15)
        
        let goal = createTestGoal(startDate: startDate, targetDate: targetDate, numberOfActiveTasks: 5, numberOfDoneTasks: 5)
        let expectedProgress = 0.5
        
        // act
        let progressCalculator = GoalProgressCalculator()
        let progress = progressCalculator.calculateProgress(forGoal: goal, forDate: testDate)
        
        // test
        XCTAssertEqual(expectedProgress, progress.progressInPercent)
        XCTAssertEqual(ProgressIndicator.onTrack, progress.indicator)
    }
}
