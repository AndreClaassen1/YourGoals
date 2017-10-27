//
//  Goal+Subgoals.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Goal {
    
    /// retrieve all subgoals
    func allGoals() -> [Goal] {
        return subGoals?.allObjects as? [Goal] ?? []
    }
    
    /// retrieve all associated tasks for this goal
    func allTasks() -> [Task] {
        return tasks?.allObjects as? [Task] ?? []
    }
    
    /// calculate the number of tasks with the given state
    ///
    /// - Parameter state: active or done
    /// - Returns: number of tasks for this state
    func numberOfTasks(forState state:TaskState) -> Int {
        return allTasks().reduce(0, { n,t in
            if t.getTaskState()  == state {
                return n + 1
            } else {
                return n
            }
        })
    }
    
    /// add a bunch of tasks to the goal
    ///
    /// - Parameter tasks: array of tasks
    func addToTasks(_ tasks:[Task]) {
        for t in tasks {
            addToTasks(t)
        }
    }
}
