//
//  WatchTasksContextProvider.swift
//  YourGoals
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

class WatchTasksContextProvider:StorageManagerWorker {

    let committedTasksDataSource:CommittedTasksDataSource!
    let activeTasksDataSource:ActiveTasksDataSource!
    
    override init(manager: GoalsStorageManager) {
        self.committedTasksDataSource = CommittedTasksDataSource(manager: manager, mode: .activeTasksNotIncluded)
        self.activeTasksDataSource = ActiveTasksDataSource(manager: manager)
        super.init(manager: manager)
    }
    
    /// retrieve the tasks for today in a representation format processable for the watch extneion
    ///
    /// - Parameters:
    ///   - date: for this date
    ///   - backburnedGoals: true, if backburnedGoals: tasks should be included
    /// - Returns: a colleciton of watch task infos
    /// - Throws: core data exception
    func todayTasks(referenceDate date: Date, withBackburned backburnedGoals: Bool) throws -> [WatchTaskInfo] {
        
        let activeTasks = try activeTasksDataSource.fetchItems(forDate: date, withBackburned: backburnedGoals, andSection: nil)
        let todayTasks = try committedTasksDataSource.fetchItems(forDate: date, withBackburned: backburnedGoals, andSection: nil)
        let allTasks = activeTasks + todayTasks
        
        let watchTasks = allTasks.map { item -> WatchTaskInfo in
            let task = item.actionable as! Task
            let watchTaskInfo = WatchTaskInfo(task: task, date: Date())
            return watchTaskInfo
        }
        
        return watchTasks
    }
    
}
