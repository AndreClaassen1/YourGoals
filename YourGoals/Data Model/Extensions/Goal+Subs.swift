//
//  Goal+Subgoals.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

extension Goal {
    
    /// retrieve all subgoals
    func allGoals() -> [Goal] {
        return subGoals?.allObjects as? [Goal] ?? []
    }
    
    /// retrieve all goals sorted by goals type (today goal first) and then by prio
    ///
    /// - Returns: sorted by prio
    func allGoalsOrderedByPrio() -> [Goal] {
        return allGoals().sorted(by: {
            if $0.type == $1.type {
                return $0.prio < $1.prio
            } else {
                return $0.type > $1.type // types are sorted descendent because of the today goal with the type 2
            }
        })
    }
    
    /// retrieve all associated tasks for this goal
    func allTasks() -> [Task] {
        return tasks?.allObjects as? [Task] ?? []
    }
    
    /// retrieve all habits
    func allHabits() -> [Habit] {
        return habits?.allObjects as? [Habit] ?? []
    }
    
    /// calculate the number of tasks with the given state
    ///
    /// - Parameter state: active or done
    /// - Returns: number of tasks for this state
    func numberOfTasks(forState state:ActionableState) -> Int {
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
    
    /// find task with the given managed object id from the sub tasks of the goal
    ///
    /// - Parameter id: object id
    /// - Returns: the task
    func taskForId(_ id:NSManagedObjectID) -> Task? {
        return allTasks().first(where: { $0.objectID == id })
    }
}
