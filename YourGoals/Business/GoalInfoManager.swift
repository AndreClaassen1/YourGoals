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
    func retrieveGoalsWithProgress() throws -> [Goal] {
        let tasks = try self.manager.tasksStore.fetchItems { request in
            request.predicate = NSPredicate(format: "ANY progress.end = nil")
        }
    
        let goals = tasks.map { $0.goal }.filter {$0 != nil}.map{$0!}
        return goals
    }
}
