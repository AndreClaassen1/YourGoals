//
//  HabitDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation



/// a data source for retrieving ordered tasks from a goal
class HabitsDataSource: ActionableDataSource, ActionablePositioningProtocol {
    let habitManager:HabitManager
    let goal:Goal?
    
    init(manager: GoalsStorageManager, forGoal goal: Goal? = nil) {
        self.habitManager  = HabitManager(manager: manager)
        self.goal = goal
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchActionables(forDate date: Date) throws -> [Actionable] {
        return try habitManager.habitsByOrder(forGoal: self.goal)
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return self
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return nil
    }
    
    // MARK: ActionablePositioningProtocol
    
    func updatePosition(actionables: [Actionable], fromPosition: Int, toPosition: Int) throws {
        try self.habitManager.updatePosition(habits: actionables.map { $0 as! Habit }, fromPosition: fromPosition, toPosition: toPosition)
    }
}
