//
//  HabitDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation



/// a data source for retrieving ordered tasks from a goal
class HabitsDataSource: ActionableDataSource, ActionablePositioningProtocol, ActionableSwitchProtocol {
    
    let habitOrderManager:HabitOrderManager
    let habitCheckManager:HabitCheckManager
    let goal:Goal?
    
    init(manager: GoalsStorageManager, forGoal goal: Goal? = nil) {
        self.habitOrderManager  = HabitOrderManager(manager: manager)
        self.habitCheckManager = HabitCheckManager(manager: manager)
        self.goal = goal
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
        return []
    }
    
    func fetchItems(forDate date: Date, withBackburned backburnedGoals: Bool, andSection: ActionableSection?) throws -> [ActionableItem] {
        let actionables = try habitOrderManager.habitsByOrder(forGoal: self.goal, backburnedGoals: backburnedGoals)
        return actionables.map { ActionableResult(actionable: $0) }
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return self
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        switch behavior {
        case .state:
            return self
        case .progress:
            return nil
        case .commitment:
            return nil
        case .tomorrow:
            return nil
            
        }
    }
    
    // MARK: ActionablePositioningProtocol
    
    func updatePosition(items: [ActionableItem], fromPosition: Int, toPosition: Int) throws {
        let habits = items.map { $0.actionable as! Habit }
        try self.habitOrderManager.updatePosition(habits: habits, fromPosition: fromPosition, toPosition: toPosition)
    }
    
    func moveIntoSection(item: ActionableItem, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }

    
    // MARK: ActionableSwitchProtocol
    
    func switchBehavior(forItem item: ActionableItem, atDate date: Date) throws {
        guard let habit = item.actionable as? Habit else {
            NSLog("couldn't get habit from actionable: \(item.actionable)")
            return
        }
        
        let checked = habit.isChecked(forDate: date)
        if checked {
            try self.habitCheckManager.checkHabit(forHabit: habit, state: .notChecked, atDate: date)
        } else {
            try self.habitCheckManager.checkHabit(forHabit: habit, state: .checked, atDate: date)
        }
    }
    
    func isBehaviorActive(forItem item: ActionableItem, atDate date: Date) -> Bool {
        guard let habit = item.actionable as? Habit else {
            NSLog("couldn't get habit from actionable: \(item.actionable)")
            return false
        }
        
        return habit.isChecked(forDate: date)
    }

}
