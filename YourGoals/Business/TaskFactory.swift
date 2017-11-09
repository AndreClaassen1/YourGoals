//
//  TaskFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// factory for creating new persistent task objects
class TaskFactory:StorageManagerWorker {
      
    /// create a new task with name and state
    ///
    /// - Parameters:
    ///   - name: name of the task
    ///   - state: state of the task
    ///   - prio: prio of the task
    /// - Returns: the task
    func create(name: String, state: ActionableState, prio:Int16) -> Task {
        let task = manager.tasksStore.createPersistentObject()
        task.name = name
        task.setTaskState(state: state)
        task.prio = prio
        return task
    }
    
    /// create a bunch of tasks for testing reasons
    ///
    /// - Parameters:
    ///   - numberOfTasks: number of tasks
    ///   - state: state
    /// - Returns: array with created tasks
    func createTasks(numberOfTasks: Int, state: ActionableState) -> [Task] {
        var tasks = [Task]()
        
        for i in 0 ..< numberOfTasks {
            let task = create(name: "Task #\(i)", state: state, prio: Int16(i))
            tasks.append(task)
        }
        
        return tasks
    }
    
    /// create a new task with the given task info
    ///
    /// - Parameter taskInfo: task info (view model)
    func create(taskInfo: TaskInfo) -> Task {
        let task = manager.tasksStore.createPersistentObject()
        task.name = taskInfo.taskName
        task.setTaskState(state: .active)
        task.prio = 999
        return task
    }
}
