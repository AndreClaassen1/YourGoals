//
//  ActiveLifeDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 22.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation


/// protocol for fetching actionables (tasks or habits) in various controllers
protocol ActionableLifeDataSource {
    
    /// fetch a ordered array of items for an active life view from the data source
    ///
    /// - Parameter
    ///   - date: fetch items for this date
    ///
    /// - Returns: an ordered array of time infos
    /// - Throws: core data exception
    func fetchTimeInfos(forDate date: Date, withBackburned backburnedGoals: Bool?) throws -> [ActionableTimeInfo]
    
    /// retrieve the reordering protocol, if the datasource allows task reordering
    ///
    /// - Returns: a protocol for exchange items
    func positioningProtocol() -> ActionablePositioningProtocol?
    
    /// get a switch protocol for a specific behavior if available for this actionable data source
    ///
    /// - Returns: a switch protol
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol?
}

/// a data source, which simulates the active life view
class ActiveLifeDataSource: ActionableLifeDataSource, ActionablePositioningProtocol {
    
    let manager:GoalsStorageManager
    let taskManager:TaskCommitmentManager
    let switchProtocolProvider:TaskSwitchProtocolProvider
    
    init(manager: GoalsStorageManager) {
        self.manager = manager
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableLifeDataSource
    
    func fetchTimeInfos(forDate date: Date, withBackburned backburnedGoals: Bool?) throws -> [ActionableTimeInfo] {
        let committedTasks = try taskManager.allCommittedTasks(forDate: date)
        let calculator = ActiveLifeScheduleCalculator(manager: self.manager)
        let timeInfos = try! calculator.calculateTimeInfoForActiveLife(forTime: date, actionables: committedTasks)
        return timeInfos
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
