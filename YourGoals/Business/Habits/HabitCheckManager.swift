//
//  HabitCheckManager.swift
//  YourGoals
//
//  Created by André Claaßen on 24.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// business functions for checking and unchecking habits
class HabitCheckManager:StorageManagerWorker {
    
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
}
