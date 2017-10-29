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
    
    /// update the order of the tasks
    ///
    /// - Parameter tasks: ordered array of tasks
    /// - Throws: core data exception
    func updateTasksOrder(tasks: [Task]) throws {
        for tuple in tasks.enumerated() {
            let prio = Int16(tuple.offset)
            let task = tuple.element
            task.prio = prio
        }
        
        try self.manager.dataManager.saveContext()
    }
    
    /// after a reorder is done, a task has changed its position from the old offset to the new offset
    ///
    /// - Parameters:
    ///   - tasks: original tasks
    ///   - fromPosition: old position of the task in the array
    ///   - toPosition: new position for the task in the array
    /// - Returns: updated task order
    func updateTaskPosition(tasks: [Task], fromPosition: Int, toPosition: Int) throws -> [Task] {
        var tasksReorderd = tasks
        tasksReorderd.rearrange(from: fromPosition, to: toPosition)
        try updateTasksOrder(tasks: tasksReorderd)
        return tasksReorderd
    }
}
