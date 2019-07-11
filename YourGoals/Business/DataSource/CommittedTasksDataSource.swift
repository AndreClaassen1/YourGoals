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
    let manager: GoalsStorageManager
    
    /// initialize the data source with the core data storage managenr
    ///
    /// - Parameters:
    ///   - manager: core data storage manager
    ///   - mode: active tasks or done tasks included or not
    init(manager: GoalsStorageManager, mode: Mode = .activeTasksIncluded) {
        self.manager = manager
        self.mode = mode
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    /// this data source doesn't provide sections
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
        return []
    }
    
    /// fetch the actionables for the date/time as Actionable time infos with start/end time and progress
    ///
    /// - Parameters:
    ///   - date: date/time
    ///   - backburnedGoals: include backburned goals or not
    ///   - andSection: this is ignored
    /// - Returns: actionable time infos
    /// - Throws: core data exception
    func fetchItems(forDate date: Date, withBackburned backburnedGoals: Bool, andSection: ActionableSection?) throws -> [ActionableItem] {
        let committedTasks = try taskManager.committedTasksTodayAndFromThePast(forDate: date, backburnedGoals: backburnedGoals)
        var tasks:[Task]!
        switch mode {
        case .activeTasksIncluded:
            tasks = committedTasks
        case .activeTasksNotIncluded:
            tasks = committedTasks.filter { !$0.isProgressing(atDate: date) }
        case .doneTasksNotIncluced:
            tasks = committedTasks.filter { $0.getTaskState() != .done  }
        }
        
        let calculator = TodayScheduleCalculator(manager: self.manager)
        let timeInfos = try calculator.calculateTimeInfos(forTime: date, actionables: tasks)
        return timeInfos
    }
    
    func positioningProtocol() -> ActionablePositioningProtocol? {
        return self
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol? {
        return self.switchProtocolProvider.switchProtocol(forBehavior: behavior)
    }
    
    // MARK: ActionablePositioningProtocol
    
    func updatePosition(items: [ActionableItem], fromPosition: Int, toPosition: Int) throws {
        let tasks = items.map { ($0.actionable as! Task) }
        
        try self.taskManager.updateTaskPosition(tasks: tasks, fromPosition: fromPosition, toPosition: toPosition)
    }
    
    func moveIntoSection(item: ActionableItem, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
    
}
