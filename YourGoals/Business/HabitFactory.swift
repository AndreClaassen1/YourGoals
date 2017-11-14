//
//  HabitFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class HabitFactory:StorageManagerWorker, ActionableFactory {
    
    /// create a new habit
    ///
    /// - Parameter name: name of the habit
    /// - Returns: a habit
    func createHabit(name: String) -> Habit {
        let habit = self.manager.habitStore.createPersistentObject()
        habit.name = name
        return habit
    }
    
    // MARK: - ActionableFactory
    
    func create(actionableInfo: ActionableInfo) -> Actionable {
        return createHabit(name: actionableInfo.name)
    }
}
