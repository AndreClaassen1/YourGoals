//
//  TestDataCreator.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

/// this class makes the creation of goals and tasks a little bit easier
class TestDataCreator:StorageManagerWorker {
    
    /// create a goal for unit testing
    ///
    /// - Parameter name: name of the goal
    /// - Returns: the goal
    func createGoal(name: String) -> Goal {
        let strategyManager = StrategyManager(manager: self.manager)
        let goal = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: name, reason: "test reasons", startDate: Date.minimalDate, targetDate: Date.maximalDate))
        return goal
    }
    
    /// create a task for unit testing for the given goal with the name
    ///
    /// - Parameters:
    ///   - name: name of the task
    ///   - goal: the goal
    /// - Returns: a new  task
    func createTask(name: String, forGoal goal: Goal) -> Task {
        let composer = GoalComposer(manager: self.manager)
        let task = try! composer.create(actionableInfo: ActionableInfo(type: .task, name: name), toGoal: goal) as! Task
        return task
    }
    
}
