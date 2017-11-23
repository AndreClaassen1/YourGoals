//
//  CommittedTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 09.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class CommittedTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
    let taskManager:TaskCommitmentManager
    let switchProtocolProvider:TaskSwitchProtocolProvider
    
    init(manager: GoalsStorageManager) {
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchActionables(forDate date: Date) throws -> [Actionable] {
        return try taskManager.committedTasksTodayAndFromTHePath(forDate: date)
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
