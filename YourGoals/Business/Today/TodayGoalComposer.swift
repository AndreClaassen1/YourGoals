//
//  TodayGoalComposer.swift
//  YourGoals
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// a helper class for creating simple tasks for the today goal
class TodayGoalComposer:StorageManagerWorker {
    
    /// a creator class for tasks/habits for goals
    let goalComposer:GoalComposer!
    /// manager for accessing the today goal
    let strategyManager:StrategyManager!
    
    /// initialize the today goal composer
    ///
    /// - Parameters:
    ///   - manager: a core data storage manager
    ///   - taskNotificationProtocol: task notification
    ///      protocol for signalling events
    init(manager: GoalsStorageManager, taskNotificationProtocol:TaskNotificationProviderProtocol = TaskNotificationObserver.defaultObserver)  {
        self.goalComposer = GoalComposer(manager: manager, taskNotificationProtocol: taskNotificationProtocol)
        self.strategyManager = StrategyManager(manager: manager)
        super.init(manager: manager)
    }
    
    /// create a task with the given description for the today goal
    ///
    /// - Parameters:
    ///   - actionableInfo: struct with all needed informations
    /// - Throws: core data exception
    func create(actionableInfo: ActionableInfo) throws {
        let strategy = try self.strategyManager.assertValidActiveStrategy()
        let todayGoal = try self.strategyManager.assertTodayGoal(strategy: strategy)
        let _ = try self.goalComposer.create(actionableInfo: actionableInfo, toGoal: todayGoal)
    }
}
