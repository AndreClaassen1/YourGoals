//
//  StrategyOrderManager.swift
//  YourGoals
//
//  Created by André Claaßen on 05.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class StrategyOrderManager:StorageManagerWorker {
    
    /// retrieve all goals for the strategy by prio
    ///
    /// - Parameter
    ///     - goalTypes: nil for all goal types or a filter of special types like userGoal or todayGoal
    ///     - backburnedGoals: include backburnedGoals: goals in the filture
    /// - Returns: the strategy
    /// - Throws: all goals by prio
    func goalsByPrio(withTypes goalTypes: [GoalType]? = nil, withBackburned backburnedGoals: Bool) throws -> [Goal] {
        let strategy = try StrategyManager(manager: self.manager).assertValidActiveStrategy()
        let goals = strategy.allGoalsByPrio(withTypes: goalTypes, withBackburned: backburnedGoals)
        return goals
    }
}
