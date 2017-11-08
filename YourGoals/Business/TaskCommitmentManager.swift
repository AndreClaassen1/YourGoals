//
//  TaskCommitmentManager.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

class TaskCommitmentManager : StorageManagerWorker, TaskPositioningProtocol {
    
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
    
    func updateTaskPosition(tasks: [Task], fromPosition: Int, toPosition: Int) throws -> [Task] {
        var tasksReorderd = tasks
        tasksReorderd.rearrange(from: fromPosition, to: toPosition)
        updateTasksOrder(tasks: tasksReorderd)
        try self.manager.dataManager.saveContext()
        return tasksReorderd
    }
}
