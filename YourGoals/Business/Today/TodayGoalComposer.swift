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
    
    init(manager: GoalsStorageManager, taskNotificationProtocol:TaskNotificationProviderProtocol = TaskNotificationObserver.defaultObserver)  {
        self.goalComposer = GoalComposer(manager: manager, taskNotificationProtocol: taskNotificationProtocol)
        self.strategyManager = StrategyManager(manager: manager)
        super.init(manager: manager)
    }
    
    /// create a task with the given description for the today goal
    ///
    /// - Parameters:
    ///   - name: the name or content of the task
    ///   - date: date to commit
    /// - Throws: core data exception
    func createTask(name: String, forDate date: Date) throws {
        let strategy = try self.strategyManager.assertValidActiveStrategy()
        let todayGoal = try self.strategyManager.assertTodayGoal(strategy: strategy)
        let actionableInfo = ActionableInfo(type: .task, name: name, commitDate: date, parentGoal: todayGoal)
        let _ = try self.goalComposer.create(actionableInfo: actionableInfo, toGoal: todayGoal)
    }
}
