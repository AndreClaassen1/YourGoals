//
//  ActiveTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

//
//  CommittedTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 09.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class ActiveTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
    let taskManager:TaskProgressManager
    let switchProtocolProvider:TaskSwitchProtocolProvider

    init(manager: GoalsStorageManager) {
        self.taskManager  = TaskProgressManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    func fetchActionables(forDate date: Date) throws -> [Actionable] {
        return try taskManager.activeTasks(forDate: date)
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return nil
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return self.switchProtocolProvider.switchProtocol(forBehavior: behavior)
    }
    
    // MARK: ActionablePositioningProtocol
    
    func updatePosition(actionables: [Actionable], fromPosition: Int, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
}
