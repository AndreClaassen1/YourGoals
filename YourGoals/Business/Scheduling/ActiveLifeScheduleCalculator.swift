//
//  ActiveLifeScheduleCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 29.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation

extension ActionableTimeInfo {
    /// create a actionable time info from a task progress record
    ///
    /// - Parameters:
    ///   - day: calculate the values for this day
    ///   - actionable: the actionable
    ///   - progress: the progress of the actionable
    init(day: Date, actionable: Actionable, progress: TaskProgress ) {
        self.startingTime = progress.startOfDay(day: day)
        self.endingTime = progress.endOfDay(day: day)
        self.remainingTimeInterval = TimeInterval(0)
        self.conflicting = false
        self.fixedStartingTime = true
        self.actionable = actionable
        self.progress = progress
    }
}


/// class for calculating starting times for the active life view
class ActiveLifeScheduleCalculator:StorageManagerWorker {
    
    /// calculate the correct starting time for a progressing item
    ///
    /// - Parameters:
    ///   - time: actual system time
    ///   - actionable: the actionable
    /// - Returns: the progressing time
    func calculateProgressStartingTime(forTime time:Date, actionable: Actionable) -> Date {
        if let task = actionable as? Task, let progress = task.progressFor(date: time), let start = progress.start {
            return start
        } else {
            return time
        }
    }
    
    /// calculate the conflicting state
    ///
    /// - Parameters:
    ///   - startTime: time to check if it conflicts against a fixed begin time for an item
    ///   - actionable: the actionable
    /// - Returns: a tuple with a conflicting state and a new start time
    func calculateConflicting(forTime startTime: Date, actionable: Actionable) -> (conflicting: Bool, fixed: Bool, startTime: Date) {
        guard let beginTime = actionable.beginTime else {
            return (false, false, startTime)
        }
        
        return (startTime.compare(beginTime) == .orderedDescending,
                true,
                beginTime)
    }
    
    /// fetch all done progress items fromt the task and create time infos out of them
    ///
    /// - Parameters:
    ///   - actionable: the task
    ///   - day: the day
    /// - Returns: an array of time infos from the done task progress records
    func timeInfosFromDoneProgress(fromActionable actionable: Actionable, andDay day:Date) -> [ActionableTimeInfo] {
        guard let task = actionable as? Task else {
            return []
        }
        
        let timeInfos = task
            .progressFor(day: day)
            .filter{ $0.state == .done }
            .map{ ActionableTimeInfo(day: day, actionable: actionable, progress: $0) }
            .sorted { $0.startingTime.compare($1.startingTime) == .orderedAscending  }
        return timeInfos
    }

    /// calculate the starting times relative to the given time for the actionables in a way similar to active life
    ///
    /// - Parameters:
    ///   - time: start time for all actionalbes
    ///   - actionables: the actinalbes
    /// - Returns: array with associated starting ties
    /// - Throws: core data exception
    func calculateTimeInfoForActiveLife(forTime time: Date, actionables:[Actionable]) throws -> [ActionableTimeInfo] {
        assert(actionables.first(where: { $0.type == .habit}) == nil, "there only tasks allowed")
        
        var timeInfos = [ActionableTimeInfo]()
        var startingTimeOfTask = time
        
        for actionable in actionables {
            timeInfos.append(contentsOf: timeInfosFromDoneProgress(fromActionable: actionable, andDay: time.day()))
            
            var startingTimeInfo:ActionableTimeInfo!
            if actionable.isProgressing(atDate: time) {
                let remainingTime = actionable.calcRemainingTimeInterval(atDate: time)
                let progressingStartingTime = calculateProgressStartingTime(forTime: time, actionable: actionable)
                startingTimeInfo = ActionableTimeInfo(start: progressingStartingTime, end: time.addingTimeInterval(remainingTime), remainingTimeInterval: remainingTime, conflicting: false, fixed: false, actionable: actionable)
                startingTimeOfTask = time.addingTimeInterval(remainingTime)
            } else {
                let tuple = calculateConflicting(forTime: startingTimeOfTask, actionable: actionable)
                startingTimeOfTask = tuple.startTime
                let remainingTime = actionable.calcRemainingTimeInterval(atDate: startingTimeOfTask)
                startingTimeInfo = ActionableTimeInfo(start: startingTimeOfTask, end: startingTimeOfTask.addingTimeInterval(remainingTime), remainingTimeInterval: remainingTime, conflicting: tuple.conflicting, fixed: tuple.fixed, actionable: actionable)
                startingTimeOfTask.addTimeInterval(remainingTime)
            }
            timeInfos.append(startingTimeInfo)
        }
        return timeInfos
    }
    
    /// calculate the start time for the longest active task
    ///
    /// - Parameter time: new starting times
    /// - Returns: a starting time relative to the longest remaining active task
    /// - Throws: a core data exception
    func calcStartTimeRelativeToActiveTasks(forTime time: Date) throws -> Date {
        let activeTasks = try TaskProgressManager(manager: self.manager).activeTasks(forDate: time)
        let maximalRemainingTime = activeTasks.reduce(TimeInterval(0.0)) { n, task in
            let remainingTime = task.calcRemainingTimeInterval(atDate: time)
            return n > remainingTime ? n: remainingTime
        }
        
        let  startTime = time.addingTimeInterval(maximalRemainingTime)
        return startTime
    }
}
