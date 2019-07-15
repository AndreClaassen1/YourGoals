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
        return date.formattedWithTodayTommorrowYesterday()
    }
    
    func calculateStartingTime(forDate date: Date) -> Date? {
        let startingTimeForSection = self.date.day().addMinutesToDate(8 * 60)
        
        if startingTimeForSection.compare(date) == .orderedDescending {
            return startingTimeForSection
        }
        
        return date
    }
}

/// a data source for a plannable and draggable action items 7 days in advance
class PlannableTasksDataSource: ActionableDataSource, ActionablePositioningProtocol {
    
    let taskManager:TaskCommitmentManager
    let calculator:TodayScheduleCalculator
    let committedDataSource:CommittedTasksDataSource
    let switchProtocolProvider:TaskSwitchProtocolProvider
    
    init(manager: GoalsStorageManager) {
        self.calculator = TodayScheduleCalculator(manager: manager)
        self.taskManager  = TaskCommitmentManager(manager: manager)
        self.committedDataSource = CommittedTasksDataSource(manager: manager, mode: .doneTasksNotIncluced)
        self.switchProtocolProvider = TaskSwitchProtocolProvider(manager: manager)
    }
    
    // MARK: ActionableTableViewDataSource
    
    /// fetch commitment dates for the next week
    ///
    /// - Returns: an array with the next 7 days
    /// - Throws: nothing
    func fetchSections(forDate date: Date, withBackburned backburnedGoals: Bool) throws -> [ActionableSection] {
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
    func fetchItems(forDate date: Date, withBackburned backburnedGoals: Bool, andSection section: ActionableSection?) throws -> [ActionableItem] {
        guard let plannableSection = section as? PlannableActionableSection else {
            NSLog("illegal section type: \(String(describing: section))")
            return []
        }
        
        guard let section = section else {
            assertionFailure("We need a section here")
            return []
        }
        
        if date.day().compare(plannableSection.date.day()) == .orderedSame {
            return try committedDataSource.fetchItems(forDate: date, withBackburned: backburnedGoals, andSection: nil)
        }
        
        let tasks = try taskManager.committedTasks(forDate: plannableSection.date, backburnedGoals: backburnedGoals)
        let startingTimeForSection = section.calculateStartingTime(forDate: date)!
        
        let timeInfos = try self.calculator.calculateTimeInfos(forTime: startingTimeForSection, actionables: tasks)
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
        let actionables = items.map { $0.actionable }
        try self.taskManager.updateTaskPosition(tasks: actionables.map { $0 as! Task }, fromPosition: fromPosition, toPosition: toPosition)
    }
    
    func moveIntoSection(item: ActionableItem, section: ActionableSection, toPosition: Int) throws {
        let actionable = item.actionable
        
        guard let task = actionable as? Task else {
            assertionFailure("function needs a task as actionable: \(actionable )")
            return
        }
        
        guard let plannableSection = section as? PlannableActionableSection else {
            assertionFailure("function needs a plannable section: \(section)")
            return
        }
        
        let tasksInSection = try taskManager.committedTasks(forDate: plannableSection.date, backburnedGoals: SettingsUserDefault.standard.backburnedGoals)
        task.commitmentDate = plannableSection.date
        
        try self.taskManager.insertTaskAtPosition(task: task, tasks: tasksInSection, toPosition: toPosition)
    }
}
