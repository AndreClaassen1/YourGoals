//
//  GoalsModelManager.swift
//  YourGoals
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

protocol GoalsModelObserver {
    func goalsChanged()
    func tasksChanged()
    func showNotification(error: Error)
}

class GoalsModelManager:StorageManagerWorker, GoalsModelUpdateDelegate {
    let taskStateManager:TaskStateManager
    let taskProgressManager:TaskProgressManager
    
    override init(manager: GoalsStorageManager) {
        self.taskStateManager = TaskStateManager(manager: manager)
        self.taskProgressManager = TaskProgressManager(manager: manager)
        super.init(manager: manager)
    }

    // MARK: - GoalsModelUpdateDelegate
    
    func taskUpdated(task: Task) {
        
    }
    
    func taskCreated(task: Task) {
        
    }
    
    func taskRemoved(task: Task) {
        
    }
    
    func goalUpdated(goal: Goal) {
        
    }
    
    func goalCreatead(goal: Goal) {
        
    }
    
    func goalRemoved(goal: Goal) {
        
    }
    
}
