//
//  GoalComposer.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

/// special errors for the GoalComposer class
///
/// - noGoalForActionableFound: no goal for the actionable found eg. the goal is nil
enum GoalComposerError:Error {
    case noGoalForActionableFound
}

/// modify and compose goals in core data and save the result in the database
class GoalComposer:StorageManagerWorker {
    
    let taskNotificationProtocol:TaskNotificationProviderProtocol

    /// initialize the goal composer
    ///
    /// - Parameters:
    ///   - manager: the storage manager
    ///   - taskNotificationProtocol: a task notification protocol for informing accociated tasks
    init(manager: GoalsStorageManager, taskNotificationProtocol:TaskNotificationProviderProtocol = TaskNotificationObserver.defaultObserver) {
        self.taskNotificationProtocol = taskNotificationProtocol
        super.init(manager: manager)
    }
    
    /// add a new task or habit with the information from the actionable info to the goal and save
    /// it back to the core data store
    ///
    /// - Parameters:
    ///   - actionableInfo: task info
    ///   - goal: the goal
    /// - Returns: the newly created actionable
    /// - Throws: core data exception
    func create(actionableInfo: ActionableInfo, toGoal goal: Goal) throws -> Actionable {
        let factory = factoryForType(actionableInfo.type)
        var actionable = factory.create(actionableInfo: actionableInfo)
        actionable.prio = -1
        goal.add(actionable: actionable)
        let taskOrderManager = TaskOrderManager(manager: self.manager)
        taskOrderManager.updateOrderByPrio(forGoal: goal, andType: actionableInfo.type)
        try self.manager.saveContext()
        self.taskNotificationProtocol.tasksChanged()
        return actionable
    }
    
    /// update a task or actionable
    ///
    /// - Parameters:
    ///   - actionable: the actionable which gets updated
    ///   - info: a info with new values for the actionable
    /// - Returns: the goal, which is updated
    /// - Throws: an exception
    func update(actionable: Actionable, withInfo info: ActionableInfo, forDate date:Date) throws -> Goal {
        guard let goal = actionable.goal else {
            throw GoalComposerError.noGoalForActionableFound
        }
        
        var actionable = actionable // make the actionable writeable.
        actionable.name = info.name
        actionable.commitmentDate  = info.commitDate
        actionable.goal = info.parentGoal
        actionable.size = info.size
        actionable.repetitions = info.repetitions ?? []
        actionable.imageData = info.imageData
        actionable.urlString = info.urlString
        
        try self.manager.saveContext()
        if actionable.isProgressing(atDate: date), let task = actionable as? Task {
            self.taskNotificationProtocol.progressChanged(forTask: task, referenceTime: date)
        }
    
        self.taskNotificationProtocol.tasksChanged()
        return goal
    }
    
    func delete(task: Task, fromGoal goal: Goal) throws {
        goal.removeFromTasks(task)
        self.manager.tasksStore.managedObjectContext.delete(task)
    }
    
    func delete(habit: Habit, fromGoal goal: Goal) throws {
        goal.removeFromHabits(habit)
        self.manager.tasksStore.managedObjectContext.delete(habit)
    }
    
    /// delete an actionable from the given goal
    ///
    /// - Parameters:
    ///   - actinable: the actionable
    ///   - goal: the parent goal for the task
    /// - Returns: the goal without the task
    /// - Throws: core data exception
    func delete(actionable: Actionable) throws -> Goal {
        guard let goal = actionable.goal else {
            throw GoalComposerError.noGoalForActionableFound
        }
        
        switch actionable.type {
        case .habit:
            try delete(habit: actionable as! Habit, fromGoal: goal)
        case .task:
             try delete(task: actionable as! Task, fromGoal: goal)
        }
        try self.manager.saveContext()
        self.taskNotificationProtocol.tasksChanged()
        return goal
    }
    
    /// create a factory for the actionable (task factory or habit factory)
    ///
    /// - Parameter type: the type of the actionalbe
    /// - Returns: the factory
    func factoryForType(_ type:ActionableType) -> ActionableFactory {
        switch type {
        case .task:
            return TaskFactory(manager: self.manager)
            
        case .habit:
            return HabitFactory(manager: self.manager)
        }
    }
}
