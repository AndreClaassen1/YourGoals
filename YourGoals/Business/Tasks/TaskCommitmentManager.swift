//
//  TaskCommitmentManager.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

class TaskCommitmentManager : StorageManagerWorker, ActionableSwitchProtocol {
    
    
    /// make a commitment to do the task for the given date.
    ///
    /// - Parameters:
    ///   - task: task
    ///   - date: date
    /// - Throws: core data excepciotn
    func commit(task: Task, forDate date: Date) throws {
        task.commitmentDate = date.day()
        task.commitmentPrio = 1
        task.setTaskState(state: .active)
        try manager.dataManager.saveContext()
    }
    
    /// deaktivate the committment
    ///
    /// - Parameter task: task
    /// - Throws: core data excepiotn
    func normalize(task: Task) throws {
        task.commitmentDate = nil
        task.commitmentPrio = 999
        try manager.dataManager.saveContext()
    }
    
    /// fetch all tasks committed for the given date
    ///
    /// - Throws: core data exception
    func committedTasks(forDate date:Date) throws -> [Task] {
        let tasks = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format: "commitmentDate == %@", date.day() as NSDate)
            request.sortDescriptors = [
                NSSortDescriptor(key: "commitmentDate", ascending: false),
                NSSortDescriptor(key: "commitmentPrio", ascending: true)
            ]
        })
        
        return tasks
    }
    
    /// fetch all tasks, which are active and committed and have a commit date younger than
    /// the given date
    ///
    /// - Parameter date: date
    /// - Returns: a list of tasks committed past the given date
    /// - Throws: core data exception
    func committedTasksPast(forDate date:Date) throws -> [Task] {
        let tasks = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format:
                "commitmentDate < %@ AND state == 0",
                                            date.day() as NSDate)
            request.sortDescriptors = [
                NSSortDescriptor(key: "commitmentDate", ascending: false),
                NSSortDescriptor(key: "commitmentPrio", ascending: true)
            ]
        })
        
        return tasks
    }
    
    /// combine the committed tasks for today and tasks of the path
    ///
    /// - Parameter date: date
    /// - Returns: a collection of actual and past committed tasks
    /// - Throws: core data exception
    func committedTasksTodayAndFromTHePath(forDate date:Date) throws -> [Task] {
        var tasks = [Task]()
    
        tasks.append(contentsOf: try committedTasks(forDate: date))
        tasks.append(contentsOf: try committedTasksPast(forDate: date))
        
        return tasks
    }
    
    // MARK: - TaskPositioningProtocol
    
    /// update the order of the tasks
    ///
    /// - Parameter tasks: ordered array of tasks
    func updateTasksOrder(tasks: [Task]) {
        for tuple in tasks.enumerated() {
            let prio = Int16(tuple.offset)
            let task = tuple.element
            task.commitmentPrio = prio
        }
    }
    
    func updateTaskPosition(tasks: [Task], fromPosition: Int, toPosition: Int) throws   {
        var tasksReorderd = tasks
        tasksReorderd.rearrange(from: fromPosition, to: toPosition)
        updateTasksOrder(tasks: tasksReorderd)
        try self.manager.dataManager.saveContext()
    }
    
    // MARK: - ActionableSwitchProtocol
    
    func switchBehavior(forActionable actionable: Actionable, atDate date: Date) throws {
        guard let task = actionable as? Task else {
            assertionFailure("switchState failed. Actionable isn't a task")
            return
        }
        
        if task.committingState(forDate: date) == .committedForDate {
            try self.normalize(task: task)
        } else {
            try self.commit(task: task, forDate: date)
        }
    }
    
    func isBehaviorActive(forActionable actionable: Actionable, atDate date: Date) -> Bool {
        return actionable.committingState(forDate: date) == .committedForDate
    }
    
    
}
