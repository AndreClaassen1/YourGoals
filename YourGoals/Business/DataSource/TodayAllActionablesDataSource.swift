//
//  TodaysAllActionableDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class TodayAllActionablesDataSource : StorageManagerWorker, ActionableDataSource {
    let backburned: Bool
    
    init(manager: GoalsStorageManager, backburned: Bool) {
        self.backburned = backburned
        super.init(manager: manager)
    }
    
    func fetchSections(forDate date: Date) throws -> [ActionableSection] {
        return []
    }
    
    func fetchActionables(forDate date: Date, andSection section: ActionableSection?) throws -> [Actionable] {
        var actionables = try CommittedTasksDataSource(manager: self.manager, backburned: backburned).fetchActionables(forDate: date, andSection: section)
        actionables.append(contentsOf: try HabitsDataSource(manager: self.manager, backburned: backburned).fetchActionables(forDate: date, andSection: section))
        return actionables
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return nil
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return nil
    }
}
