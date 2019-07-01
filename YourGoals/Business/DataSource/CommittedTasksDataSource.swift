//
//  CommittedTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 09.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// data source for the classical today view about all committed tasks for a day.
/// this includes tasks of the day before
class CommittedTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
 
    enum Mode {
        case activeTasksIncluded
        case activeTasksNotIncluded
        case doneTasksNotIncluced
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
    
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
        return []
    }
    
    func fetchActionables(forDate date: Date, withBackburned backburnedGoals: Bool, andSection: ActionableSection?) throws -> [Actionable] {
        let committedTasks = try taskManager.committedTasksTodayAndFromThePast(forDate: date, backburnedGoals: backburnedGoals)
        switch mode {
        case .activeTasksIncluded:
            return committedTasks
        case .activeTasksNotIncluded:
            return committedTasks.filter { !$0.isProgressing(atDate: date) }
        case .doneTasksNotIncluced:
            return committedTasks.filter { $0.getTaskState() != .done  }
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
    
    func moveIntoSection(actionable: Actionable, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
    
}
