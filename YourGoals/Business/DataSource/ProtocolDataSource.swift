//
//  ProtocolDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// progress on a goal for a given date
struct ProtocolGoalInfo:Hashable {
    let goal:Goal
    let date:Date
    
    init(goal: Goal, date:Date) {
        self.goal = goal
        self.date = date
    }
}

/// progress on a task for a given date
protocol ProtocolProgressInfo {
    var title:String { get }
    var sortingDate:Date { get }
    
    func timeRange(onDate: Date) -> String
    func workedTime(onDate: Date) -> TimeInterval
    func progress(onDate: Date) -> Double
}

/// a info about worked time on a task for a time range.
struct TaskProgressInfo:ProtocolProgressInfo {
    let progress:TaskProgress

    var sortingDate:Date {
        return progress.start ?? Date.minimalDate
    }
    
    func workedTime(onDate date: Date) -> TimeInterval {
        return progress.timeInterval(on: date)
    }
    
    func timeRange(onDate date: Date) -> String {
        let day = date.day()
        let startTime = progress.start ?? day.startOfDay
        let endTime = progress.end ?? date
        
        return "\(startTime.formattedTime()) - \(endTime.formattedTime())"
    }
    
    var title: String {
        return self.progress.task?.name ?? "Kein Task bekannt"
    }
    
    /// progress for this goal in percent
    ///
    /// - Parameter onDate: the date, where I made progress for
    /// - Returns: the progress
    func progress(onDate: Date) -> Double {
        let calculator = TaskProgressCalculator()
        return calculator.calculateProgressOnGoal(taskProgress: self.progress, forDate: onDate)
    }
    
    init(progress: TaskProgress) {
        self.progress = progress
    }
}

// an information about a done task.
struct DoneTaskInfo:ProtocolProgressInfo {
    func progress(onDate: Date) -> Double {
        return 0.0
    }
    
    var sortingDate:Date {
        return self.task.doneDate ?? Date.minimalDate
    }

    
    func workedTime(onDate: Date) -> TimeInterval {
        return 0
    }
    
    func timeRange(onDate date: Date) -> String {
        return "undefined"
    }
    
    var title: String
    var timeRange: String {
        return " ./. "
    }
    
    var task:Task
    
    init(task: Task) {
        self.title = task.name ?? "undefined task"
        self.task = task
    }
    
}

struct HabitProgressInfo:ProtocolProgressInfo {
    func progress(onDate: Date) -> Double {
        return 0.0
    }
    
    func workedTime(onDate: Date) -> TimeInterval {
        return 0
    }
    
    func timeRange(onDate date: Date) -> String {
        return "undefined"
    }
    
    var sortingDate: Date {
        return Date.minimalDate
    }
        
    var title: String
    var timeRange: String
}

protocol ProtocolProgressProvider {
    func fetchGoalInfos(forDate date:Date) throws -> [ProtocolGoalInfo]
    func fetchProtocolProgress(forGoalInfno goalInfo:ProtocolGoalInfo) throws -> [ProtocolProgressInfo]
}

class TaskProgressProvider:ProtocolProgressProvider {
    let manager:GoalsStorageManager
    
    init(manager:GoalsStorageManager) {
        self.manager = manager
    }
    
    func fetchGoalInfos(forDate date:Date) throws -> [ProtocolGoalInfo] {
        let startOfDay = date.startOfDay
        let endOfDay = date.endOfDay
        
        let goals = try self.manager.goalsStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format:
                "SUBQUERY(tasks, $t, " +
                    "SUBQUERY($t.progress, $progress, $progress.start >= %@ AND $progress.end <= %@).@count > 0" +
                ").@count > 0", startOfDay as NSDate, endOfDay as NSDate)
        })
        
        return goals.map { ProtocolGoalInfo(goal: $0, date: date) }
    }
    
    func fetchProtocolProgress(forGoalInfno goalInfo:ProtocolGoalInfo) throws -> [ProtocolProgressInfo] {
        let startOfDay = goalInfo.date.startOfDay
        let endOfDay = goalInfo.date.endOfDay
        let progress = try self.manager.taskProgressStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format: "task.goal = %@ && start >= %@ AND end <= %@", goalInfo.goal, startOfDay as NSDate, endOfDay as NSDate)
        }).map { TaskProgressInfo(progress: $0) }
        return progress
    }
}

class DoneTaskProvider:ProtocolProgressProvider {
    let manager:GoalsStorageManager
    
    init(manager:GoalsStorageManager) {
        self.manager = manager
    }

    func fetchGoalInfos(forDate date: Date) throws -> [ProtocolGoalInfo] {
        let startOfDay = date.startOfDay
        let endOfDay = date.endOfDay
        
        let goals = try self.manager.goalsStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format:
                "SUBQUERY(tasks, $task, $task.doneDate >= %@ AND $task.doneDate <= %@ ).@count > 0", startOfDay as NSDate, endOfDay as NSDate)
        })
        
        let goalInfos = goals.map { ProtocolGoalInfo(goal: $0, date: date)}
        
        return goalInfos
    }
    
    func fetchProtocolProgress(forGoalInfno goalInfo: ProtocolGoalInfo) throws -> [ProtocolProgressInfo] {
        let startOfDay = goalInfo.date.startOfDay
        let endOfDay = goalInfo.date.endOfDay
        let progress = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format: "goal = %@ && doneDate >= %@ AND doneDate <= %@", goalInfo.goal, startOfDay as NSDate, endOfDay as NSDate)
        }).map { DoneTaskInfo(task: $0) }
        return progress
    }
}

/// a data source for providing a protocol info
class ProtocolDataSource : StorageManagerWorker {
    
    let protocolProviders:[ProtocolProgressProvider]
    
    override init(manager:GoalsStorageManager) {
        self.protocolProviders = [
            TaskProgressProvider(manager: manager),
            DoneTaskProvider(manager: manager)
        ]
        
        super.init(manager: manager)
    }
    
    /// fetch all goal worked on the given day
    ///
    /// - Parameter date: the date
    /// - Returns: array of ProtocolGoalInfo
    /// - Throws: a core data exception
    func fetchWorkedGoals(forDate date: Date) throws -> [ProtocolGoalInfo] {
        var goalInfos = [ProtocolGoalInfo]()
        for provider in self.protocolProviders {
            goalInfos.append(contentsOf: try provider.fetchGoalInfos(forDate: date))
        }
        
        // eliminate duplicates
        let uniqueGoalInfos = goalInfos.uniqued()
        return uniqueGoalInfos
    }

    /// fetch progress items for a goal for the given date
    ///
    /// - Parameters
    ///   - goalInfo: the goal info structiore
    /// - Returns: an array of Protocol Progress Info Items
    /// - Throws: Core Data Exception
    func fetchProgressOnGoal(goalInfo: ProtocolGoalInfo) throws -> [ProtocolProgressInfo] {
        var progress = [ProtocolProgressInfo]()
        for provider in self.protocolProviders {
            progress.append(contentsOf: try provider.fetchProtocolProgress(forGoalInfno: goalInfo))
        }
        
        let sortedProgress = progress.sorted(by: {
            $0.sortingDate.compare($1.sortingDate) == .orderedDescending
        })
        
        return sortedProgress
    }
}
