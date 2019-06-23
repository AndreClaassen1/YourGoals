//
//  TodaysAllActionableDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class TodayAllActionablesDataSource : StorageManagerWorker, ActionableDataSource {
    
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
        return []
    }
    
    func fetchActionables(forDate date: Date, withBackburned backburnedGoals: Bool, andSection section: ActionableSection?) throws -> [(Actionable, StartingTimeInfo?)] {
        var actionables = try CommittedTasksDataSource(manager: self.manager).fetchActionables(forDate: date, withBackburned: backburnedGoals, andSection: section)
        actionables.append(contentsOf: try HabitsDataSource(manager: self.manager).fetchActionables(forDate: date, withBackburned: backburnedGoals, andSection: section))
        return actionables
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return nil
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return nil
    }
}
