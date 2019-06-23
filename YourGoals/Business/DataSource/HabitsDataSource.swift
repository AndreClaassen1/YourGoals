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
    
    func fetchActionables(forDate date: Date, withBackburned backburnedGoals: Bool, andSection: ActionableSection?) throws -> [(Actionable, StartingTimeInfo?)] {
        return try habitOrderManager.habitsByOrder(forGoal: self.goal, backburnedGoals: backburnedGoals).map { ($0, nil) }
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
    
    func updatePosition(actionables: [Actionable], fromPosition: Int, toPosition: Int) throws {
        try self.habitOrderManager.updatePosition(habits: actionables.map { $0 as! Habit }, fromPosition: fromPosition, toPosition: toPosition)
    }
    
    func moveIntoSection(actionable: Actionable, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }

    
    // MARK: ActionableSwitchProtocol
    
    func switchBehavior(forActionable actionable: Actionable, atDate date: Date) throws {
        guard let habit = actionable as? Habit else {
            NSLog("couldn't get habit from actionable: \(actionable)")
            return
        }
        
        let checked = habit.isChecked(forDate: date)
        if checked {
            try self.habitCheckManager.checkHabit(forHabit: habit, state: .notChecked, atDate: date)
        } else {
            try self.habitCheckManager.checkHabit(forHabit: habit, state: .checked, atDate: date)
        }
    }
    
    func isBehaviorActive(forActionable actionable: Actionable, atDate date: Date) -> Bool {
        guard let habit = actionable as? Habit else {
            NSLog("couldn't get habit from actionable: \(actionable)")
            return false
        }
        
        return habit.isChecked(forDate: date)
    }

}
