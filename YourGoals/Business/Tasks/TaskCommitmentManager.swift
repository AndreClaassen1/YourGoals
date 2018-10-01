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
        NotificationCenter.default.post(Notification(name: StrategyModelNotification.commitStateChanged.name, object: task, userInfo: nil))
    }
    
    /// deaktivate the committment
    ///
    /// - Parameter task: task
    /// - Throws: core data excepiotn
    func normalize(task: Task) throws {
        task.commitmentDate = nil
        task.commitmentPrio = 999
        try manager.dataManager.saveContext()
        NotificationCenter.default.post(Notification(name: StrategyModelNotification.commitStateChanged.name, object: task, userInfo: nil))
    }
    
    /// fetch all tasks committed for the given date
    ///
    /// - Throws: core data exception
    func committedTasks(forDate date:Date, backburnedGoals: Bool) throws -> [Task] {
        let tasks = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = backburnedGoals ?
                NSPredicate(format: "commitmentDate == %@", date.day() as NSDate) :
                  NSPredicate(format: "commitmentDate == %@ AND goal.backburnedGoals == NO", date.day() as NSDate)
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
    func committedTasksPast(forDate date:Date, backburnedGoals: Bool) throws -> [Task] {
        let tasks = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = backburnedGoals ?
                NSPredicate(format: "commitmentDate < %@ AND state == 0", date.day() as NSDate) :
                NSPredicate(format: "commitmentDate < %@ AND state == 0 AND goal.backburnedGoals == NO", date.day() as NSDate)
                
            request.sortDescriptors = [
                NSSortDescriptor(key: "commitmentDate", ascending: false),
                NSSortDescriptor(key: "commitmentPrio", ascending: true)
            ]
        })
        
        return tasks
    }
    
    /// even the uncommitted tasks for the today goal are implicit committed.
    ///
    /// - Returns: tasks accociated with the today goal
    /// - Throws: core data excepiton
    func uncommittedTasksForTodayGoal(backburnedGoals: Bool) throws -> [Task] {
        let strategyManager = StrategyManager(manager: self.manager)
        let todayGoal = try strategyManager.assertTodayGoal(strategy: try strategyManager.assertValidActiveStrategy())
        let tasks = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = backburnedGoals ?
                NSPredicate(format: "commitmentDate == nil AND goal == %@", todayGoal) :
                NSPredicate(format: "commitmentDate == nil AND goal == %@ AND goal.backburnedGoals == NO", todayGoal)
            
            request.sortDescriptors = [
                NSSortDescriptor(key: "commitmentPrio", ascending: true)
            ]
        })
        
        return tasks
    }
    
    /// commitment group is needed for sorting committed tasks for today
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - date: check commitment date against date
    /// - Returns: 0: commitmentDate == date
    ///            1: commitmentDate == past
    ///            2: everything else
    func commitmentGroup(task:Task, forDate date:Date) -> Int {
        let date = date.day()
        
        guard let commitmentDate  = task.commitmentDate?.day() else {
            return 2
        }
        
        if commitmentDate.compare(date) == .orderedSame { return 0 }
        if commitmentDate.compare(date) == .orderedDescending { return 1}
        return 2
    }
    
    /// combine the committed tasks for today and tasks of the path
    ///
    /// - Parameter date: date
    /// - Returns: a collection of actual and past committed tasks
    /// - Throws: core data exception
    func committedTasksTodayAndFromThePast(forDate date:Date, backburnedGoals: Bool) throws -> [Task] {
        var tasks = [Task]()
    
        tasks.append(contentsOf: try committedTasks(forDate: date, backburnedGoals: backburnedGoals))
        tasks.append(contentsOf: try committedTasksPast(forDate: date, backburnedGoals: backburnedGoals))
        tasks.append(contentsOf: try uncommittedTasksForTodayGoal(backburnedGoals: backburnedGoals))
        
        let sorted = tasks.sorted { (t1, t2) -> Bool in
            if t1.state != t2.state {
                return t1.state < t2.state
            }
            
            return commitmentGroup(task: t1, forDate: date) < commitmentGroup(task: t2, forDate: date)
        }
        
        return sorted
    }
    
    /// fetch all tasks which have a commitmentdate
    ///
    /// - Parameter date: date
    /// - Returns: a collection of all committed tasks
    /// - Throws: core data exception
    func allCommittedTasks(forDate date:Date) throws -> [Task] {
        let tasks = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format:
                "commitmentDate != nil",
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
    
    func updateTaskPosition(tasks: [Task], fromPosition: Int, toPosition: Int) throws   {
        var tasksReorderd = tasks
        tasksReorderd.rearrange(from: fromPosition, to: toPosition)
        updateTasksOrder(tasks: tasksReorderd)
        try self.manager.dataManager.saveContext()
    }

    func insertTaskAtPosition(task: Task, tasks: [Task], toPosition: Int) throws   {
        var tasksReorderd = tasks
        tasksReorderd.insert(task, at: toPosition)
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
