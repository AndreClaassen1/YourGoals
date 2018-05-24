//
//  TodayGoalComposer.swift
//  YourGoals
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

class TodayGoalComposer:StorageManagerWorker {
    
    let goalComposer:GoalComposer!
    let strategyManager:StrategyManager!
    
    override init(manager: GoalsStorageManager)  {
        self.goalComposer = GoalComposer(manager: manager)
        self.strategyManager = StrategyManager(manager: manager)
        super.init(manager: manager)
    }
    
    /// create a task with the given description for the today goal
    ///
    /// - Parameters:
    ///   - description: description of the task
    ///   - date: date to commit
    /// - Throws: core data exception
    func addTask(withDescription description: String, forDate date: Date) throws {
        let strategy = try self.strategyManager.assertValidActiveStrategy()
        let todayGoal = try self.strategyManager.assertTodayGoal(strategy: strategy)
        
        let actionableInfo = ActionableInfo(type: .task, name: description, commitDate: date, parentGoal: todayGoal, size: 30.0)
        let _ = try self.goalComposer.create(actionableInfo: actionableInfo, toGoal: todayGoal)
    }
}
