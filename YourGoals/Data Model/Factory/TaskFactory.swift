//
//  TaskFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class TaskFactory {
    let manager:GoalsStorageManager
    
    init(manager: GoalsStorageManager) {
        self.manager = manager
    }
    
    /// create a new task with name and state
    ///
    /// - Parameters:
    ///   - name: name of the task
    ///   - state: state of the task
    /// - Returns: the task
    func create(name: String, state: TaskState) -> Task {
        let task = manager.tasksStore.createPersistentObject()
        task.name = name
        task.setTaskState(state: state)
        return task
    }
}
