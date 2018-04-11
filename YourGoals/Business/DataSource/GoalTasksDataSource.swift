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
    
    func fetchSections(forDate date: Date) throws -> [ActionableSection] {
        return []
    }
    
    func fetchActionables(forDate date: Date, andSection: ActionableSection?) throws -> [Actionable] {
        return try taskManager.tasksByOrder(forGoal: goal)
    }
    
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return self
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return self.switchProtocolProvider.switchProtocol(forBehavior: behavior)
    }
    
    // MARK: ActionablePositioningProtocol
    
    func updatePosition(actionables: [Actionable], fromPosition: Int, toPosition: Int) throws {
        try self.taskManager.updateTaskPosition(tasks: actionables.map { $0 as! Task }, fromPosition: fromPosition, toPosition: toPosition)
    }
    
    func moveIntoSection(actionable: Actionable, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
}
