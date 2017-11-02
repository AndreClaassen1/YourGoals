//
//  Strategy.swift
//  YourGoals
//
//  Created by André Claaßen on 24.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

enum StrategyManagerError : Error{
    case activeStrategyMissingError
}

extension StrategyManagerError:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .activeStrategyMissingError:
            return "There is no active strategy available. operation aborted"
        }
    }
}

class StrategyManager {
    let manager:GoalsStorageManager
    
    init(manager:GoalsStorageManager) {
        self.manager = manager
    }
    
    func assertActiveStrategy() throws -> Goal {
        let strategy = try activeStrategy()
    
        if strategy == nil {
            let newStrategy = try GoalFactory(manager: self.manager).create(name: "Strategy", prio: 0, reason: "Master Plan", startDate: Date.minimalDate, targetDate: Date.maximalDate, image: nil)
            try self.manager.dataManager.saveContext()
            return newStrategy
        }
        
        return strategy!
    }
    
    func activeStrategy() throws -> Goal? {
        return try self.manager.goalsStore.fetchFirstEntry {
            $0.predicate = NSPredicate(format: "(parentGoal = nil)")
        }
    }
    
    /// add the goal to the current strategy and save it back to the data base
    ///
    /// - Parameter goal: the goal
    /// - Returns: a new strategy
    /// - Throws: core data exception
    func saveIntoStrategy(goal: Goal) throws -> Goal  {
        guard let strategy = try self.activeStrategy() else {
            throw StrategyManagerError.activeStrategyMissingError
        }
        strategy.addToSubGoals(goal)
        try manager.dataManager.saveContext()
        return strategy
    }
}
