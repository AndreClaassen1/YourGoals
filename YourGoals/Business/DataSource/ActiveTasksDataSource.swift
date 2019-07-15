//
//  ActiveTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class ActiveTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
    
    let taskManager:TaskProgressManager
    let switchProtocolProvider:TaskSwitchProtocolProvider
    let calculator:TodayScheduleCalculator

    init(manager: GoalsStorageManager) {
        self.calculator = TodayScheduleCalculator(manager: manager)
        self.taskManager  = TaskProgressManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
        return []
    }
    
    func fetchItems(forDate date: Date, withBackburned backburnedGoals: Bool, andSection: ActionableSection?) throws -> [ActionableItem] {
        let tasks = try taskManager.activeTasks(forDate: date)
        let timeInfos = try calculator.calculateTimeInfos(forTime: date, actionables: tasks)
        return timeInfos
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return nil
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return self.switchProtocolProvider.switchProtocol(forBehavior: behavior)
    }
    
    // MARK: ActionablePositioningProtocol
    
    func updatePosition(items: [ActionableItem], fromPosition: Int, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
    
    func moveIntoSection(item: ActionableItem, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
}
