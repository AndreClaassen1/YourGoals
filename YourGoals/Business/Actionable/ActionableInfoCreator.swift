//
//  ActionableInfoCreator.swift
//  YourGoals
//
//  Created by André Claaßen on 24.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// stateless helper class for creating new actionableInfo objects for a given goal type
class ActionableInfoCreator {
    
    /// create a new actionable info for the goal.
    ///
    /// - Parameters:
    ///   - type: habit or task
    ///   - goal: the goal
    ///   - date: date which will be used for the commit date
    /// - Returns: a new actionable info
    func create(type: ActionableType, forGoal goal:Goal, forDate date: Date) -> ActionableInfo {
        switch goal.goalType() {
        case .todayGoal:
            return ActionableInfo(type: type, name: nil, commitDate: date.day(), parentGoal: goal)
        case .userGoal:
            return ActionableInfo(type: type, name: nil, commitDate: nil, parentGoal: goal)
        case .strategyGoal:
            assertionFailure("it shouldn't possible to create a strategy goal here")
            return ActionableInfo(type: type, name: nil)
        }
    }
}
