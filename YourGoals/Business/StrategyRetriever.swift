//
//  Strategy.swift
//  YourGoals
//
//  Created by André Claaßen on 24.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class StrategyRetriever {
    let manager:GoalsStorageManager
    
    init(manager:GoalsStorageManager) {
        self.manager = manager
    }
    
    func activeStrategy() throws -> Goal? {
        return try self.manager.goalsStore.fetchFirstEntry {
            $0.predicate = NSPredicate(format: "(parentGoal = nil)")
        }
    }
}
