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
    
    /// the goal
    let goal:Goal
    
    /// the date for this info
    let date:Date
    
    /// initialize the goal info with the corresponding goal and date
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - date: the date for retrieving the protocol for this goal
    init(goal: Goal, date:Date) {
        self.goal = goal
        self.date = date
    }
    
    /// calculate the whole working time on this goal
    ///
    /// - Parameters:
    ///   - manager: the goal manager
    ///   - backburnedGoals: the number of backburned goals
    /// - Returns: the time interval
    /// - Throws: a core data exception
    func workedOnGoal(manager: GoalsStorageManager, backburnedGoals: Bool) throws -> TimeInterval {
        let taskProgressProvider = TaskProgressProvider(manager: manager, backburnedGoals: backburnedGoals)
        let progress = try taskProgressProvider.fetchProtocolProgress(forGoalInfno: self)
        let workedOnGoal = progress.reduce(TimeInterval(0)) { $0 + $1.workedTime(onDate: self.date) }
        return workedOnGoal
    }
}

/// a progress info type for displaying the right icons in the UI
///
/// - doneTask: a task, which was checked as done
/// - taskProgress: a progress of work on a task
/// - habitProgress: a habit that was checked
enum ProtocolProgressInfoType {
    case doneTask
    case taskProgress
    case habitProgress
}

/// abstracted progress for a goal on a given date
///
/// The progress could be a checked habit, a done task or some work time for a task
protocol ProtocolProgressInfo {
    
    
    /// type of the progress: a done task, some work on a task or a checked habit
    var type:ProtocolProgressInfoType { get }
    
    /// name or title of the task/habit of the progress
    var title:String { get }
    
    /// sorting date to sort a progress
    var sortingDate:Date { get }
    
    /// description of the time, where you worked on the goal
    ///
    /// - Parameter onDate: a reference date for calculations
    /// - Returns: a representation of progress time as a string
    func timeRange(onDate: Date) -> String
    
    /// time interval where you worked on progress. it is needed for calculations
    ///
    /// - Parameter onDate: the date
    /// - Returns: a time interval for this progress
    func workedTime(onDate: Date) -> TimeInterval
    
    /// a description of the progress you made. it coulde be a percentage value
    /// or an indication, how often you checked your habit
    ///
    /// - Parameter onDate: the date
    /// - Returns: a description of the progress you made
    func progressDescription(onDate: Date) -> String
}

/// a info about worked time on a task for a time range.
struct TaskProgressInfo:ProtocolProgressInfo {
    
    /// a goal storage manager
    let manager:GoalsStorageManager
    
    /// true, if backburned goals should be included in the calculation
    let backburnedGoals:Bool
    
    /// this is a task proress
    let type = ProtocolProgressInfoType.taskProgress
    
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
        return (self.progress.task?.name ?? "undefined")
    }
    
    /// progress for this goal in percent
    ///
    /// - Parameter onDate: the date, where I made progress for
    /// - Returns: the progress
    func progress(onDate: Date) -> Double {
        let calculator = TaskProgressCalculator(manager: self.manager, backburnedGoals: self.backburnedGoals)
        return calculator.calculateProgressOnGoal(taskProgress: self.progress, forDate: onDate)
    }
    
    /// create a description string which includes the progress made on the goal so far.
    ///
    /// - Parameters:
    ///   - protocolInfo: the protocol info with the percentage of the progress
    ///   - date: the date as the foundation for the calculation
    /// - Returns: a formatted string: "You made 3% progress on your goal!"
    func progressDescription(onDate date:Date) -> String {
        let percentage = self.progress(onDate: date)
        if percentage == 0.0 {
            return "You made no progress on your goal!"
        } else {
            let percentageString = String.localizedStringWithFormat("%.2f", percentage * 100.0)
            return "You made \(percentageString)% progress on your goal!"
        }
    }
}

// an information about a done task.
struct DoneTaskInfo:ProtocolProgressInfo {
    /// a goal storage manager
    let manager:GoalsStorageManager
    
    /// true, if backburned goals should be included
    let backburnedGoals:Bool
    
    /// the task where the is made
    let task:Task
    
    /// the name of the task
    let title:String
    
    /// this is a done task progress
    let type = ProtocolProgressInfoType.doneTask

    /// initialize this info the progress data
    ///
    /// - Parameters:
    ///   - manager: a goal storage manager
    ///   - task: the task which was checked as done
    ///   - backburnedGoals: true, if backburned goals should be included in the calculation
    init(manager: GoalsStorageManager, task: Task, backburnedGoals: Bool) {
        self.manager = manager
        self.task = task
        self.title = (task.name ?? "undefined task")
        self.backburnedGoals = backburnedGoals
    }

    /// calculate the progress of the task relative to the size of all tasks for the goal
    ///
    /// - Parameter date: date as a refrence for calculating
    /// - Returns: the percentage between 0.0 and 1.0
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
    
    /// a date for sorting the tasks
    var sortingDate:Date {
        return self.task.doneDate ?? Date.minimalDate
    }

    /// time interval with the work of the task for this date
    ///
    /// - Parameter date: the date
    /// - Returns: a time interval for the summed working time for this task
    func workedTime(onDate date: Date) -> TimeInterval {
        let calculator = TaskWorktimeCalculator()
        return calculator.calculateWorktime(task: self.task, date: date)
    }
    
    /// a description of the amount of work for this task.
    ///
    /// - Parameter date: the date
    /// - Returns: a string representation of the work time
    func timeRange(onDate date: Date) -> String {
        let workedTime = self.workedTime(onDate: date)
        return "Your worktime \(workedTime.formattedAsString())"
    }
    
    /// create a description string which includes the progress made on the goal so far.
    ///
    /// - Parameters:
    ///   - protocolInfo: the protocol info with the percentage of the progress
    ///   - date: the date as the foundation for the calculation
    /// - Returns: a formatted string: "You made 3% progress on your goal!"
    func progressDescription(onDate date:Date) -> String {
        let percentage = self.progress(onDate: date)
        if percentage == 0.0 {
            return "You made no progress on your goal!"
        } else {
            let percentageString = String.localizedStringWithFormat("%.2f", percentage * 100.0)
            return "You made \(percentageString)% progress on your goal!"
        }
    }
}

/// a progress info for a checked habit
struct HabitProgressInfo:ProtocolProgressInfo {
    
    /// the habit
    let habit: Habit
    
    /// initialize this progress with the habit which was checked in
    ///
    /// - Parameter habit: the habit
    init(habit: Habit) {
        self.habit = habit
    }
    
    /// work time on habits isn't available
    ///
    /// - Parameter onDate: the date
    /// - Returns: 0.0
    func workedTime(onDate: Date) -> TimeInterval {
        return 0
    }
    
    /// a time range for a habit is not available
    ///
    /// - Parameter date: the date
    /// - Returns: an empty string
    func timeRange(onDate date: Date) -> String {
        return ""
    }
    
    /// sorting for habits not available. sort them down.
    var sortingDate: Date {
        return Date.minimalDate
    }
        
    /// the title of the habit
    var title: String {
        return habit.name ?? "unknown habit"
    }
    
    /// this is a progress on a checked habit
    let type = ProtocolProgressInfoType.habitProgress
    
    /// create a description string which includes the progress made on the goal so far.
    ///
    /// - Parameters:
    ///   - protocolInfo: the protocol info with the percentage of the progress
    ///   - date: the date as the foundation for the calculation
    /// - Returns: a formatted string: "You made 3% progress on your goal!"
    func progressDescription(onDate date:Date) -> String {
        let strokeCount = HabitStrokeCalculator().calculateStrokeCount(forHabit: self.habit , andDate: date)
        switch strokeCount {
        case 0: return "You don't have done this habit today."
        case 1: return "Congratulation! You've done this habit today."
        default: return "Great! You've repeated this habit \(strokeCount) times."
        }
    }
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
