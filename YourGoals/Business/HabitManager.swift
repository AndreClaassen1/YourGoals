//
//  HabitManager.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class HabitManager:StorageManagerWorker {
    
    /// delete all check instances for the date. there is usually only one instance
    ///
    /// - Parameters:
    ///   - habit: the habit
    ///   - date: the date
    func deleteAllChecks(forHabit habit:Habit, atDate date: Date) {
        let checks = habit.allHabitChecks().filter{ $0.check == date.day() }
        for habitCheck in checks {
            habit.removeFromChecks(habitCheck)
            manager.context.delete(habitCheck)
        }
    }
    
    /// check the habit for the given date and save the result in the database
    ///
    /// - Parameters:
    ///   - habit: the habit
    ///   - state: .checked or .unchecked state for the date
    ///   - date: the date to check or uncheck
    /// - Throws: core data exception
    func checkHabit(forHabit habit:Habit, state: HabitCheckedState, atDate date: Date) throws {
        let dayDate = date.day()
        
        deleteAllChecks(forHabit: habit, atDate: dayDate)
        if state == .checked {
            let habitCheck = manager.habitCheckStore.createPersistentObject()
            habitCheck.check = dayDate
            habit.addToChecks(habitCheck)
        }
        
        try self.manager.context.save()
    }
    
    func habitsByOrder(forGoal goal:Goal) throws -> [Habit] {
        let habits = try self.manager.habitStore.fetchItems { request in
            request.predicate = NSPredicate(format: "goal == %@", goal)
            request.sortDescriptors = [NSSortDescriptor(key: "prio", ascending: true)]
        }
        return habits
    }
    
    func allHabits() throws -> [Habit] {
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
