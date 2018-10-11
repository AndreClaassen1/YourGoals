//
//  GoalDeleter.swift
//  YourGoals
//
//  Created by André Claaßen on 30.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class GoalDeleter:StorageManagerWorker {
    
    /// delete a goal and its task from the core data store
    ///
    /// - Parameter goal: the goal
    /// - Throws: core data exception
    func delete(goal:Goal) throws {
        for task in goal.allTasks() {
            self.manager.tasksStore.managedObjectContext.delete(task)
        }
        
        goal.subGoals = nil
        if let parentGoal = goal.parentGoal {
            parentGoal.removeFromSubGoals(goal)
        }
        
        self.manager.goalsStore.managedObjectContext.delete(goal)
    
        try self.manager.saveContext()
    }
}
