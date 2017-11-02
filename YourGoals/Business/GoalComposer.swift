//
//  GoalComposer.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

enum GoalComposerError:Error {
    case noTaskForIdFound
}

/// modify and compose goals in core data and save the result in the database
class GoalComposer {
    let manager:GoalsStorageManager
    
    init(manager: GoalsStorageManager) {
        self.manager = manager
    }
    
    /// add a new task with the information from the task info to the goal and save
    /// it back to the core data store
    ///
    /// - Parameters:
    ///   - taskInfo: task info
    ///   - goal: the goal
    /// - Returns: the modified goal with the new task
    /// - Throws: core data exception
    func add(taskInfo: TaskInfo, toGoal goal: Goal) throws -> Goal {
        let taskFactory = TaskFactory(manager: self.manager)
        let task = taskFactory.create(taskInfo: taskInfo)
        task.prio = -1
        goal.addToTasks(task)
        let taskOrderManager = TaskOrderManager(manager: self.manager)
        try taskOrderManager.updateTasksOrder(tasks: goal.allTasks())
        try self.manager.dataManager.saveContext()
        return goal
    }

    /// update a task for a goal withnew valuees
    ///
    /// - Parameters:
    ///   - taskInfo: task info
    ///   - id: object id of the task
    ///   - goal: the goal
    /// - Returns: the modified goal with the updated task
    /// - Throws: core data exception
    func update(taskInfo: TaskInfo, withId id: NSManagedObjectID, toGoal goal: Goal) throws -> Goal {
        guard let task = goal.taskForId(id) else {
            throw GoalComposerError.noTaskForIdFound
        }
        
        task.name = taskInfo.taskName
        try self.manager.dataManager.saveContext()
        return goal
    }
    
    /// delete a task with id from the given goal
    ///
    /// - Parameters:
    ///   - id: object id from the task
    ///   - goal: the parent goal for the task
    /// - Returns: the goal without the task
    /// - Throws: core data exception
    func delete(taskWithId id:NSManagedObjectID, fromGoal goal: Goal) throws -> Goal {
        guard let task = goal.taskForId(id) else {
            throw GoalComposerError.noTaskForIdFound
        }

        goal.removeFromTasks(task)
        self.manager.tasksStore.managedObjectContext.delete(task)
        try self.manager.dataManager.saveContext()
        return goal
    }

}
