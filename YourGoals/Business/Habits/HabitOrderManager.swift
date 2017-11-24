//
//  HabitManager.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class HabitOrderManager:StorageManagerWorker {
    func habitsByOrder(forGoal goal:Goal?) throws -> [Habit] {
        let habits = try self.manager.habitStore.fetchItems { request in
            if let goal = goal {
                request.predicate = NSPredicate(format: "goal == %@", goal)
            }
            
            request.sortDescriptors = [NSSortDescriptor(key: "prio", ascending: true)]
        }
        return habits
    }
    
    func habitsByOrder() throws -> [Habit] {
        let habits = try self.manager.habitStore.fetchItems { request in
            request.sortDescriptors = [NSSortDescriptor(key: "prio", ascending: true)]
        }
        return habits
    }
    
    /// update the order of the tasks
    ///
    /// - Parameter tasks: ordered array of tasks
    func updateOrder(habits: [Habit]) {
        for tuple in habits.enumerated() {
            let prio = Int16(tuple.offset)
            let habit = tuple.element
            habit.prio = prio
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
    func updatePosition(habits: [Habit], fromPosition: Int, toPosition: Int) throws  {
        var reordered = habits
        reordered.rearrange(from: fromPosition, to: toPosition)
        updateOrder(habits: reordered)
        try self.manager.dataManager.saveContext()
    }
}