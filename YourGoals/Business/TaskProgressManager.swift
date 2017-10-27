//
//  TaskProgressManager.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

/// errors for the Task progress maanger
///
/// - noProgressNeedActiveTask: you can't start/stop progress on a non active task
enum TaskProgressError : Error {
    case noProgressNeedActiveTask
}

// MARK: - error descriptions
extension TaskProgressError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noProgressNeedActiveTask:
            return "you need an active task to start or stop making progress"
        }
    }
}

/// business class to start and stop progress on a task and modifieing state in the database
class TaskProgressManager {
    let manager:GoalsStorageManager
    
    /// initialize the TaskProgressManager with a core data manager
    ///
    /// - Parameter manager: a GoalsStoreManager
    init(manager: GoalsStorageManager) {
        self.manager = manager
    }
    
    /// start working and making progress on a task
    ///
    /// **Important**: If the task is not active, it will be made active again
    ///
    /// - Parameters:
    ///   - task: start progress on this task
    ///   - date: at this date
    /// - Throws: core data exception
    func startProgress(forTask task: Task, atDate date: Date) throws {
        if !task.taskIsActive() {
            let stateManager = TaskStateManager(manager: self.manager)
            try stateManager.setTaskState(task: task, state: .active, atDate: date)
        }
        
        if task.isProgressing(atDate: date) {
            return
        }
        
        let taskProgress = manager.taskProgressStore.createPersistentObject()
        taskProgress.start = date
        taskProgress.end = nil
        task.addToProgress(taskProgress)
        
        try self.manager.dataManager.saveContext()
    }
    
    /// stop working and making progress on a task
    ///
    /// - Parameters:
    ///   - task: stop working on this task
    ///   - date: at this date
    /// - Throws: core data exception
    func stopProgress(forTask task: Task, atDate date: Date) throws {
        guard task.taskIsActive() else {
            throw TaskProgressError.noProgressNeedActiveTask
        }
        
        guard let activeProgress = task.progressFor(date: date) else {
            return
        }
        
        activeProgress.end = date
        try self.manager.dataManager.saveContext()
    }
}
