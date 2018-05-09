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
        let strategyManager = StrategyManager(manager: self.manager)
        
        let goal = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: "Test goal for calculation", reason: "no reason", startDate: startDate, targetDate: targetDate))
        
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
        let progressCalculator = GoalProgressCalculator(manager: self.manager)
        let progress = try! progressCalculator.calculateProgress(forGoal: goal, forDate: testDate, withBackburned: true)
        
        // test
        XCTAssertEqual(expectedProgress, progress.progress)
        XCTAssertEqual(ProgressIndicator.onTrack, progress.indicator)
    }
}
