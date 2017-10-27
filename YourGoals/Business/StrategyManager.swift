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
    
    func activeStrategy() throws -> Goal? {
        return try self.manager.goalsStore.fetchFirstEntry {
            $0.predicate = NSPredicate(format: "(parentGoal = nil)")
        }
    }
    
    /// add the goal to the current strategy and save it back to the data base
    ///
    /// - Parameter goal: the goal
    /// - Throws: core data exception
    func saveIntoStrategy(goal: Goal) throws {
        guard let strategy = try self.activeStrategy() else {
            throw StrategyManagerError.activeStrategyMissingError
        }
        strategy.addToSubGoals(goal)
        try manager.dataManager.saveContext()
    }
}
