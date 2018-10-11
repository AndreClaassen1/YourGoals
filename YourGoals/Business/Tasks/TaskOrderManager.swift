//
//  TaskPrioManager.swift
//  YourGoals
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

extension ActionableType {
    
    /// get the name of the entity in core data for the actionable type
    ///
    /// - Returns: name of the entity
    func entityName() -> String {
        switch self {
        case .habit:
            return "Habit"
        case .task:
            return "Task"
        }
    }
}

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
            request.sortDescriptors = [
                NSSortDescriptor(key: "state", ascending: true),
                NSSortDescriptor(key: "prio", ascending: true)
            ]
        }
        return tasks
    }
    
    /// update the order of actionables by prio and "renumber" the prio in the tasks
    ///
    /// - Parameter goal: update the task order for this goal
    func updateOrderByPrio(forGoal goal: Goal, andType type:ActionableType) {
        let actionablesSortedByPrio = goal.all(actionableType: type).sorted(by: { $0.prio < $1.prio })
        updateOrder(actionables: actionablesSortedByPrio, type: type)
    }

    /// update the order of actionabels by renumbering the prio in order to the offset in the array
    ///
    /// - Parameter tasks: ordered array of tasks
    func updateOrder(actionables: [Actionable], type: ActionableType) {
        for tuple in actionables.enumerated() {
            let prio = Int16(tuple.offset)
            var actionable = tuple.element
            actionable.prio = prio
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
        updateOrder(actionables: tasksReorderd, type: .task)
        try self.manager.saveContext()
    }
}
