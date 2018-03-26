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
class TaskProgressManager:StorageManagerWorker, ActionableSwitchProtocol {
    /// start working and making progress on a task
    ///
    /// **Important:**
    ///  - If the task is not active, it will be made active again
    ///  - the commitment date of the task will be set to today
    ///
    /// - Parameters:
    ///   - task: start progress on this task
    ///   - date: at this date
    /// - Throws: core data exception
    func startProgress(forTask task: Task, atDate date: Date) throws {
        try stopProgressForAllTasks(atDate: date)
        
        if !task.taskIsActive() {
            let stateManager = TaskStateManager(manager: self.manager)
            try stateManager.setTaskState(task: task, state: .active, atDate: date)
        }
        
        // is there a runnig progression?
        if let oldProgress = task.progressFor(date: date) {
            oldProgress.end = date // stop it at date
        }
        
        // create new progress
        let newProgress = manager.taskProgressStore.createPersistentObject()
        newProgress.start = date
        newProgress.end = nil
        task.addToProgress(newProgress)
        task.commitmentDate = date.day()
        
        try self.manager.dataManager.saveContext()
    }
    
    /// stop working and making progress on a task
    ///
    /// - Parameters:
    ///   - task: stop working on this task
    ///   - date: at this date
    /// - Throws: core data exception
    func stopProgress(forTask task: Task, atDate date: Date) throws {
        guard let activeProgress = task.progressFor(date: date) else {
            return
        }
        
        activeProgress.end = date
        try self.manager.dataManager.saveContext()
    }
    
    /// stop progress from all tasks at the given date
    /// - Parameter date: this is the end date for all open progress
    /// - Throws: core data exception
    func stopProgressForAllTasks(atDate date: Date) throws {
        let activeProgress = try self.manager.taskProgressStore.fetchItems { request in
            request.predicate = NSPredicate(format: "end = nil" )
        }
        
        for progress in activeProgress {
            progress.end = date
        }
    }
    
    /// retrieve all active tasks started before the given dateactive
    ///
    /// - Parameter date: the dateactive
    /// - Returns: array of tasks with active progress (usually only max. one task)
    /// - Throws: a core data exception
    func activeTasks(forDate date: Date) throws -> [Task] {
        let progress = try self.manager.taskProgressStore.fetchItems(qualifyRequest: {
            $0.predicate = NSPredicate(format: "end = nil AND start <= %@", date as NSDate)
        })
        
        return progress.map { $0.task }.filter{ $0 != nil }.map{ $0! }
    }

    /// fetches the number of tasks with progress from the core data sotre
    ///
    /// Important Note: In reality this number should be 0 or 1 because
    /// there couldn't be more than one task with a progress
    ///
    /// - Returns: number of tasks with progress
    /// - Throws: core data exception
    func numberOfTasksWithProgress() throws -> Int {
        let n = try self.manager.taskProgressStore.countEntries(qualifyRequest: {
            $0.predicate = NSPredicate(format: "end = nil")
        })
        
        return n
    }
    
    // MARK: - ActionableSwitchProtocol
    
    /// switch behaviour eg. starting stopping a task progress
    ///
    /// - Parameters:
    ///   - actionable: the task
    ///   - date: the date
    /// - Throws: throws an excpeiont
    func switchBehavior(forActionable actionable: Actionable, atDate date: Date) throws {
        guard let task = actionable as? Task else {
            assertionFailure("switchState failed. Actionable isn't a task")
            return
        }
    
        if task.isProgressing(atDate: date) {
            try self.stopProgress(forTask: task, atDate: date)
        } else {
            try self.startProgress(forTask: task, atDate: date)
        }
    }
    
    func isBehaviorActive(forActionable actionable: Actionable, atDate date: Date) -> Bool {
        return actionable.isProgressing(atDate: date)
    }
    
    
    func changeTaskSize(forTask actionable: Actionable, delta: Float) throws {
        guard let task = actionable as? Task else {
            NSLog("change task size is only supported for tasks")
            return
        }
        
        task.size += delta
        if task.size < 0.0 {
            task.size = 0.0
        }
        
        try self.manager.saveContext()
    }
}
