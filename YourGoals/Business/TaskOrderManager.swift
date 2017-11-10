//
//  TaskPrioManager.swift
//  YourGoals
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// priority management for tasks
class TaskOrderManager:StorageManagerWorker {

    /// retrieve the tasks ordered from the core data store for the given goal
    ///
    /// - Parameter goal: the goal
    /// - Returns: tasks by order
    /// - Throws: core data exception
    func tasksByOrder(forGoal goal: Goal) throws -> [Task] {
        let tasks = try self.manager.tasksStore.fetchItems { request in
            request.predicate = NSPredicate(format: "goal == %@", goal)
            request.sortDescriptors = [NSSortDescriptor(key: "prio", ascending: true)]
        }
        return tasks
    }
    
    /// update the task order by prio and "renumber" the prio in the tasks
    ///
    /// - Parameter goal: update the task order for this goal
    func updateTasksOrderByPrio(forGoal goal: Goal) {
        let taskSortedByPrio = goal.allTasks().sorted(by: { $0.prio < $1.prio })
        updateTasksOrder(tasks: taskSortedByPrio)
    }

    /// update the order of the tasks
    ///
    /// - Parameter tasks: ordered array of tasks
    func updateTasksOrder(tasks: [Task]) {
        for tuple in tasks.enumerated() {
            let prio = Int16(tuple.offset)
            let task = tuple.element
            task.prio = prio
        }
    }
    
    // MARK: - TaskPositioningProtocol
    
    /// after a reorder is done, a task has changed its position from the old offset to the new offset
    ///
    /// - Parameters:
    ///   - tasks: original tasks
    ///   - fromPosition: old position of the task in the array
    ///   - toPosition: new position for the task in the array
    /// - Returns: updated task order
    func updateTaskPosition(tasks: [Task], fromPosition: Int, toPosition: Int) throws  {
        var tasksReorderd = tasks
        tasksReorderd.rearrange(from: fromPosition, to: toPosition)
        updateTasksOrder(tasks: tasksReorderd)
        try self.manager.dataManager.saveContext()
    }
}
