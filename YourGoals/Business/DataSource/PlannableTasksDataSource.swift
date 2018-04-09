//
//  PlannableTasksDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 07.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

struct PlannableActionableSection:ActionableSection {
    let date:Date
    
    /// return the date as section title
    var sectionTitle: String {
        return date.formattedInLocaleFormat()
    }
}

class PlannableTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
    
    let taskManager:TaskCommitmentManager
    let switchProtocolProvider:TaskSwitchProtocolProvider
    
    init(manager: GoalsStorageManager) {
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    /// fetch commitment dates for the next week
    ///
    /// - Returns: an array with the next 7 days
    /// - Throws: nothing
    func fetchSections(forDate date: Date) throws -> [ActionableSection] {
        let today = date.day()
        var sections = [ActionableSection]()
        
        for n in 0...6 {
            sections.append(PlannableActionableSection(date: today.addDaysToDate(n)))
        }
        
        return sections
    }
    
    /// fetch the tasks for the date in the actionable  section
    ///
    /// - Parameters:
    ///   - date: a reference date for calculating progress
    ///   - section: a section which has the date for fetching actionables
    /// - Returns: committed tasks for the section
    /// - Throws: core data exception
    func fetchActionables(forDate date: Date, andSection section: ActionableSection?) throws -> [Actionable] {
        guard let plannableSection = section as? PlannableActionableSection else {
            NSLog("illegal section type: \(section)")
            return []
        }
        
        let tasks = try taskManager.committedTasks(forDate: plannableSection.date)
        return tasks
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
