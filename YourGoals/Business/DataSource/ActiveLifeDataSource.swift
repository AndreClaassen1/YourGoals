//
//  ActiveLifeDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 22.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation


/// a data source, which simulates the active life view
class ActiveLifeDataSource: ActionableDataSource, ActionablePositioningProtocol {
    
    let taskManager:TaskCommitmentManager
    let switchProtocolProvider:TaskSwitchProtocolProvider
    
    init(manager: GoalsStorageManager) {
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
        return []
    }
    
    func fetchActionables(forDate date: Date, withBackburned backburnedGoals: Bool, andSection: ActionableSection?) throws -> [(Actionable, StartingTimeInfo?)] {
        let committedTasks = try taskManager.allCommittedTasks(forDate: date)
        return committedTasks.map { ($0, nil) }
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
