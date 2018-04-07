//
//  CommittedTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 09.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class CommittedTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
    
    enum Mode {
        case activeTasksIncluded
        case activeTasksNotIncluded
    }
    
    let taskManager:TaskCommitmentManager
    let switchProtocolProvider:TaskSwitchProtocolProvider
    let mode: Mode
    
    init(manager: GoalsStorageManager, mode: Mode = .activeTasksIncluded) {
        self.mode = mode
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchSections(forDate date: Date) throws -> [ActionableSection] {
        return []
    }
    
    func fetchActionables(forDate date: Date, andSection: ActionableSection?) throws -> [Actionable] {
        let committedTasks = try taskManager.committedTasksTodayAndFromThePast(forDate: date)
        switch mode {
        case .activeTasksIncluded:
            return committedTasks
        case .activeTasksNotIncluded:
            return committedTasks.filter { !$0.isProgressing(atDate: date) }
        }
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
}
