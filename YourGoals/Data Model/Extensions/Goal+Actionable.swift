//
//  Goal+Actionable.swift
//  YourGoals
//
//  Created by André Claaßen on 11.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Goal {
    
    /// add the actionable to the goal
    ///
    /// - Parameter actionable: actionable
    func add(actionable: Actionable) {
        switch actionable.type {
        case .habit:
            self.addToHabits(actionable as! Habit)
        case .task:
            self.addToTasks(actionable as! Task)
        }
    }
    
    /// access all objects for a type
    ///
    /// - Parameter actionableType: .task or .habit
    /// - Returns: a collection of all actionables (tasks or habits)
    func all(actionableType: ActionableType) -> [Actionable] {
        switch actionableType {
        case .habit:
            return self.allHabits()
        case .task:
            return self.allTasks()
        }
    }
}
