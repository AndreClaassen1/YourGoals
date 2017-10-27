//
//  TaskFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// factory for creating new persistent task objects
class TaskFactory {
    let manager:GoalsStorageManager
    
    /// init with a core data storage manager
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
    
    /// create a bunch of tasks for testing reasons
    ///
    /// - Parameters:
    ///   - numberOfTasks: number of tasks
    ///   - state: state
    /// - Returns: array with created tasks
    func createTasks(numberOfTasks: Int, state: TaskState) -> [Task] {
        var tasks = [Task]()
        
        for i in 0..<numberOfTasks {
            let task = create(name: "Task #\(i)", state: state)
            tasks.append(task)
        }
        
        return tasks
    }
}
