//
//  TaskStateManager.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// changes the state of a task
class TaskStateManager:ActionableSwitchProtocol {
    
    let manager:GoalsStorageManager
    
    /// init with the core data manager
    ///
    /// - Parameter manager: a GoalsStorageManager
    init(manager: GoalsStorageManager) {
        self.manager = manager
    }
    
    /// change the state of a task
    ///
    /// **Important**: If the task is currently in progress, it will be stopped
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - state: state
    /// - Throws: core data exception
    func setTaskState(task: Task, state: ActionableState, atDate date: Date) throws {
        guard task.getTaskState() != state else {
            NSLog("didn't changed the state of task \(task)")
            return
        }
    
        task.setTaskState(state: state)
        
        // if task is progressing, it will be stopped
        if state == .done && task.isProgressing(atDate: date) {
            let progressManager = TaskProgressManager(manager: self.manager)
            try progressManager.stopProgress(forTask: task, atDate: date)
        }

        // set done date only in state done
        task.doneDate = state == .done ? date : nil
        
        try manager.dataManager.saveContext()
    
        NotificationCenter.default.post(name: StrategyModelNotification.taskStateChanged.name, object: task)
    }
    
    // MARK: - ActionableSwitchProtocol
    
    func switchBehavior(forActionable actionable: Actionable, atDate date: Date) throws {
        guard let task = actionable as? Task else {
            assertionFailure("switchState failed. Actionable isn't a task")
            return
        }
        
        let date = date.day()
        
        if task.taskIsActive() {
            try self.setTaskState(task: task, state: .done, atDate: date)
        } else {
            try self.setTaskState(task: task, state: .active, atDate: date)
        }
    }
    
    func isBehaviorActive(forActionable actionable: Actionable, atDate date: Date) -> Bool {
        return actionable.checkedState(forDate: date) == .active
    }
}
