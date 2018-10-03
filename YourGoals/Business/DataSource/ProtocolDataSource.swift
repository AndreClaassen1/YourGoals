//
//  ProtocolDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// this goal has some progress on a given date.
struct ProtocolGoalInfo:Hashable {
    let goal:Goal
    let date:Date
    
    init(goal: Goal, date:Date) {
        self.goal = goal
        self.date = date
    }
}

/// abstracted progress for a goal on a given date
///
/// The progress could be a checked habit, a done task or some work time for a task
protocol ProtocolProgressInfo {
    var title:String { get }
    var sortingDate:Date { get }
    
    func timeRange(onDate: Date) -> String
    func workedTime(onDate: Date) -> TimeInterval
    func progress(onDate: Date) -> Double
}

/// a info about worked time on a task for a time range.
struct TaskProgressInfo:ProtocolProgressInfo {
    
    let manager:GoalsStorageManager
    let backburnedGoals:Bool
    
    /// the progress on the task
    let progress:TaskProgress
    
    /// initialize this info the progress data
    ///
    /// - Parameter progress: the task progress data from core data
    init(manager: GoalsStorageManager, progress: TaskProgress, backburnedGoals: Bool) {
        self.manager = manager
        self.progress = progress
        self.backburnedGoals = backburnedGoals
    }

    /// the date for sorting purposes
    var sortingDate:Date {
        return progress.start ?? Date.minimalDate
    }
    
    /// a time interval for the work time relative to the given day in the date
    ///
    /// - Parameter date: the date as a base for calculating the work tim
    /// - Returns: an interval with start and end for the given day.
    func workedTime(onDate date: Date) -> TimeInterval {
        return progress.timeInterval(on: date)
    }
    
    /// a formatted string with represents the time range worked on this task
    ///
    /// - Parameter date: the excact date
    /// - Returns: a time range
    func timeRange(onDate date: Date) -> String {
        let day = date.day()
        let startTime = progress.start ?? day.startOfDay
        let endTime = progress.end ?? date
        
        return "\(startTime.formattedTime()) - \(endTime.formattedTime())"
    }
    
    /// the title of the task for this work time
    var title: String {
        return "Progress: " + (self.progress.task?.name ?? "undefined")
    }
    
    /// progress for this goal in percent
    ///
    /// - Parameter onDate: the date, where I made progress for
    /// - Returns: the progress
    func progress(onDate: Date) -> Double {
        let calculator = TaskProgressCalculator(manager: self.manager, backburnedGoals: self.backburnedGoals)
        return calculator.calculateProgressOnGoal(taskProgress: self.progress, forDate: onDate)
    }
}

// an information about a done task.
struct DoneTaskInfo:ProtocolProgressInfo {
    let manager:GoalsStorageManager
    let backburnedGoals:Bool
    let task:Task
    let title:String
    
    /// initialize this info the progress data
    init(manager: GoalsStorageManager, task: Task, backburnedGoals: Bool) {
        self.manager = manager
        self.task = task
        self.title = "Done: " + (task.name ?? "undefined task")
        self.backburnedGoals = backburnedGoals
    }

    func progress(onDate date: Date) -> Double {
        do {
            let goalProgressCalculator = GoalProgressCalculator(manager: self.manager)
            let progress = try goalProgressCalculator.calculateProgressOnActionable(forGoal: self.task.goal!,
                                                                                    actionable: self.task, andDate: date,
                                                                                    withBackburned: backburnedGoals)
            return progress
        }
        catch let error {
            NSLog("error calculating progress for a done task: \(task), \(error)")
            return 0.0
        }
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
    
    var timeRange: String {
        return " ./. "
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

/// abstracted protocol vor the various protocol types for the protocol data source
protocol ProtocolProgressProvider {
    /// fetch the goals where is work activity for the given date
    ///
    /// - Parameter date: the date
    /// - Returns: an arry of goals workred on this day
    /// - Throws: core data exception
    func fetchGoalInfos(forDate date:Date) throws -> [ProtocolGoalInfo]
    
    /// fetch detailed progress infos for a goal info
    ///
    /// - Parameter goalInfo: the goal info
    /// - Returns: an array of detailed protocol progress infos
    /// - Throws: core data exception
    func fetchProtocolProgress(forGoalInfno goalInfo:ProtocolGoalInfo) throws -> [ProtocolProgressInfo]
}

/// a provider for progress based on worked time for on tsks
class TaskProgressProvider:ProtocolProgressProvider {
    
    /// core data storage manager
    let manager:GoalsStorageManager
    let backburnedGoals:Bool
    
    /// initialize the task provider
    ///
    /// - Parameter manager: core data storage manager
    init(manager:GoalsStorageManager, backburnedGoals:Bool) {
        self.manager = manager
        self.backburnedGoals = backburnedGoals
    }
    
    /// fetch all goals where is progress on a givne date
    ///
    /// Technical note: this provider uses a nested subquery statement
    ///
    /// - Parameter date: the given date
    /// - Returns: progress for the given date
    /// - Throws: core data exception
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
    
    /// fetch the task progress for the given date and goal
    ///
    /// - Parameter goalInfo: goal and date
    /// - Returns: an array of Task progress infos.
    /// - Throws: core data exception
    func fetchProtocolProgress(forGoalInfno goalInfo:ProtocolGoalInfo) throws -> [ProtocolProgressInfo] {
        let startOfDay = goalInfo.date.startOfDay
        let endOfDay = goalInfo.date.endOfDay
        let progress = try self.manager.taskProgressStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format: "task.goal = %@ && start >= %@ AND end <= %@", goalInfo.goal, startOfDay as NSDate, endOfDay as NSDate)
        }).map { TaskProgressInfo(manager: self.manager, progress: $0, backburnedGoals: self.backburnedGoals) }
        return progress
    }
}

/// a protocol provider for tasks which are marked as done for agiven date
class DoneTaskProvider:ProtocolProgressProvider {
    /// the goal storage manager
    let manager:GoalsStorageManager
    let backburnedGoals:Bool
    
    /// initialize the task provider
    ///
    /// - Parameter manager: core data storage manager
    init(manager:GoalsStorageManager, backburnedGoals:Bool) {
        self.manager = manager
        self.backburnedGoals = backburnedGoals
    }
    
    /// fetch all goals, where at least one task was marked as done
    ///
    /// - Parameter date: the date
    /// - Returns: an array of goals, where at least on task was masked at done for date
    /// - Throws: core data exception
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
    
    /// fetch progress infos for all tasks which are marked as done for the goal on the given date
    ///
    /// - Parameter goalInfo: a goal and a date
    /// - Returns: an array of done task infos
    /// - Throws: core data exception
    func fetchProtocolProgress(forGoalInfno goalInfo: ProtocolGoalInfo) throws -> [ProtocolProgressInfo] {
        let startOfDay = goalInfo.date.startOfDay
        let endOfDay = goalInfo.date.endOfDay
        let progress = try self.manager.tasksStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format: "goal = %@ && doneDate >= %@ AND doneDate <= %@", goalInfo.goal, startOfDay as NSDate, endOfDay as NSDate)
        }).map { DoneTaskInfo(manager: self.manager, task: $0, backburnedGoals: self.backburnedGoals) }
        return progress
    }
}

/// a data source for providing data on goals which was worked for on a given date.
/// this data source is used in the ProtocolTableViewController to show a table with goals and
/// infos about the work which was done for the goals
class ProtocolDataSource : StorageManagerWorker {
    
    /// protocol progress providers for work on tasks, marked task as done and habits
    let protocolProviders:[ProtocolProgressProvider]
    
    /// initialize the protocol data source with a core data storage manager
    ///
    /// - Parameter manager: core data storage manager
    init(manager:GoalsStorageManager, backburnedGoals: Bool) {
        self.protocolProviders = [
            TaskProgressProvider(manager: manager, backburnedGoals: backburnedGoals),
            DoneTaskProvider(manager: manager, backburnedGoals: backburnedGoals)
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
