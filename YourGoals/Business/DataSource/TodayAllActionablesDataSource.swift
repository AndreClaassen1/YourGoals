//
//  TodaysAllActionableDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class TodayAllActionablesDataSource : StorageManagerWorker, ActionableDataSource {
    func fetchActionables(forDate date: Date) throws -> [Actionable] {
        var actionables = try CommittedTasksDataSource(manager: self.manager).fetchActionables(forDate: date)
        actionables.append(contentsOf: try HabitsDataSource(manager: self.manager).fetchActionables(forDate: date))
        return actionables
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return nil
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return nil
    }
    
    
}
