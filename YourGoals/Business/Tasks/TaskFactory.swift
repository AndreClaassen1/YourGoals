//
//  TaskFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// factory for creating new persistent task objects
class TaskFactory:StorageManagerWorker, ActionableFactory {
      
    /// create a new task with name and state
    ///
    /// - Parameters:
    ///   - name: name of the task
    ///   - state: state of the task
    ///   - prio: prio of the task
    ///   - sizeInMinutes: size of the task in minutes. Default is 30 Minutes
    /// - Returns: the task
    func create(name: String, state: ActionableState, prio:Int16, sizeInMinutes: Float = 30) -> Task {
        let task = manager.tasksStore.createPersistentObject()
        task.name = name
        task.setTaskState(state: state)
        task.prio = prio
        task.size = sizeInMinutes
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
    /// - Parameter actionableInfo: task info (view model)
    func createTask(actionableInfo: ActionableInfo) -> Task {
        let task = manager.tasksStore.createPersistentObject()
        task.name = actionableInfo.name
        task.setTaskState(state: .active)
        task.prio = 999
        task.size = actionableInfo.size
        task.commitmentDate = actionableInfo.commitDate
        task.goal = actionableInfo.parentGoal
        task.repetitions = actionableInfo.repetitions ?? []
        task.url = actionableInfo.url
        task.imageData = actionableInfo.imageData
        return task
    }
    
    // Mark: - ActionableFactory
    
    func create(actionableInfo: ActionableInfo) -> Actionable {
        let task:Task = createTask(actionableInfo: actionableInfo)
        return task
    }
}
