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

class StrategyManager:StorageManagerWorker {
    
    var strategy:Goal? = nil
    
    func assertActiveStrategy() throws -> Goal {
        let strategy = try activeStrategy()
    
        if strategy == nil {
            let newStrategy = try GoalFactory(manager: self.manager).create(name: "Strategy", prio: 0, reason: "Master Plan", startDate: Date.minimalDate, targetDate: Date.maximalDate, image: nil)
            try self.manager.dataManager.saveContext()
            self.strategy = newStrategy
            return newStrategy
        }
        
        return strategy!
    }
    
    func activeStrategy() throws -> Goal? {
        if strategy != nil {
            return strategy
        }
        
        
        self.strategy =  try self.manager.goalsStore.fetchFirstEntry {
            $0.predicate = NSPredicate(format: "(parentGoal = nil)")
        }
        
        return self.strategy
    }
    
    /// add the goal to the current strategy and save it back to the data base
    ///
    /// - Parameter goal: the goal
    /// - Returns: a newly created goal
    /// - Throws: core data exception
    func createNewGoalForStrategy(goalInfo: GoalInfo) throws -> Goal  {
        guard let strategy = try self.activeStrategy() else {
            throw StrategyManagerError.activeStrategyMissingError
        }
        let goal = try GoalFactory(manager: self.manager).create(fromGoalInfo: goalInfo)
        strategy.addToSubGoals(goal)
        try manager.dataManager.saveContext()
        return goal
    }
}
