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
///
/// This data source generates only actionable time infos out of done progress and active task items
class ActiveLifeDataSource: ActionableLifeDataSource, ActionablePositioningProtocol {
    
    let manager:GoalsStorageManager
    let taskManager:TaskCommitmentManager
    let switchProtocolProvider:TaskSwitchProtocolProvider
    
    /// intialize with a core data storage manager
    ///
    /// - Parameter manager: the storage manager
    init(manager: GoalsStorageManager) {
        self.manager = manager
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableLifeDataSource
    
    /// fetch the time infos needed for the active life data source
    ///
    /// - Parameters:
    ///   - date: date/time to calculate the items
    ///   - backburnedGoals: true, if backburned tasks should be considered
    ///
    /// - Returns: time infos which represent the active life data view
    /// - Throws: core data exceptions
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
    
    func updatePosition(items: [ActionableItem], fromPosition: Int, toPosition: Int) throws {
        assertionFailure("this method needs to be coded!")
        // try self.taskManager.updateTaskPosition(tasks: actionables.map { $0 as! Task }, fromPosition: fromPosition, toPosition: toPosition)
    }
    
    func moveIntoSection(item: ActionableItem, section: ActionableSection, toPosition: Int) throws {
        assertionFailure("this method shouldn't be called")
    }
}
