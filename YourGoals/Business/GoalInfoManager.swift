//
//  GoalInfoManager.swift
//  YourGoals
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

class GoalInfoManager:StorageManagerWorker {
    
    /// retrieve all goals with active tasks.
    ///
    /// - Returns: an array of goals, which should usally only have maximal one item.
    func retrieveGoalsWithProgress(forDate date: Date) throws -> [Goal] {

        // brute force
        
        let activeStrategy = try StrategyManager(manager: self.manager).activeStrategy()!
        let goalsWithProgress = activeStrategy.allGoals().filter{ $0.isActive(forDate: date) }
        return goalsWithProgress
        
        
        //        var goalsWithProgress = [Goal]()
//        let strategyManager = StrategyManager(manager: self.manager)
//        guard let goals = try strategyManager.activeStrategy()?.allGoals() else {
//            return []
//        }
//
//        return []
       
//        let tasks = try self.manager.tasksStore.fetchItems { request in
//            request.predicate = NSPredicate(format: "ANY (progress.start != nil AND progress.end == nil)")
//        }
//
//        let goals = tasks.map { $0.goal }.filter {$0 != nil}.map{$0!}
//        return goals
    }
}
