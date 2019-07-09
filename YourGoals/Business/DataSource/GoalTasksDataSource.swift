//
//  GoalTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// a data source for retrieving ordered tasks from a goal
class GoalTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
    
    let taskManager:TaskOrderManager
    let goal:Goal
    let switchProtocolProvider:TaskSwitchProtocolProvider

    init(manager: GoalsStorageManager, forGoal goal: Goal) {
        self.taskManager  = TaskOrderManager(manager: manager)
        self.goal = goal
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
        return []
    }
    
    func fetchItems(forDate date: Date, withBackburned backburnedGoals: Bool, andSection: ActionableSection?) throws -> [ActionableItem] {
        let actionables = try taskManager.tasksByOrder(forGoal: goal)
        let items = actionables.map { ActionableResult(actionable: $0) }
        return items
    }
    
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return self
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return self.switchProtocolProvider.switchProtocol(forBehavior: behavior)
    }
    
    // MARK: ActionablePositioningProtocol
    
    func updatePosition(items: [ActionableItem], fromPosition: Int, toPosition: Int) throws {
        try self.taskManager.updateTaskPosition(tasks: items.map { $0.actionable as! Task }, fromPosition: fromPosition, toPosition: toPosition)
    }
    
    func moveIntoSection(item: ActionableItem, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
}
