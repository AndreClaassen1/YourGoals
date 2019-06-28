//
//  TodayTableCellCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 11.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// class for calculating starting times
class TodayScheduleCalculator:StorageManagerWorker {
    
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
    
    /// calculate the starting times drelative to the given time for the actionables.
    ///
    /// - Parameters:
    ///   - time: start time for all actionalbes
    ///   - actionables: the actinalbes
    /// - Returns: array with associated starting ties
    /// - Throws: core data exception
    func calculateStartingTimes(forTime time: Date, actionables:[Actionable]) throws -> [(Actionable, ActionableTimeInfo)] {
        assert(actionables.first(where: { $0.type == .habit}) == nil, "there only tasks allowed")

        var startingTimes = [(Actionable, ActionableTimeInfo)]()
        var startTime = try calcStartTimeRelativeToActiveTasks(forTime: time).extractTime()
        
        for actionable in actionables {
            var startingTimeInfo:ActionableTimeInfo!
            
            if actionable.isProgressing(atDate: time) {
                let remainingTime = actionable.calcRemainingTimeInterval(atDate: time)
                let start = calculateProgressStartingTime(forTime: time, actionable: actionable)
                startingTimeInfo = ActionableTimeInfo(start: start, end: time.addingTimeInterval(remainingTime), remainingTimeInterval: remainingTime, conflicting: false, fixed: false, actionable: actionable)
                
            } else {
                let tuple = calculateConflicting(forTime: startTime, actionable: actionable)
                startTime = tuple.startTime
                let remainingTime = actionable.calcRemainingTimeInterval(atDate: startTime)
                startingTimeInfo = ActionableTimeInfo(start: startTime, end: startTime.addingTimeInterval(remainingTime), remainingTimeInterval: remainingTime, conflicting: tuple.conflicting, fixed: tuple.fixed, actionable: actionable)
                startTime.addTimeInterval(remainingTime)
            }
            startingTimes.append((actionable, startingTimeInfo))
        }
        
        return startingTimes
    }
    
    /// calculate the starting times relative to the given time for the actionables in a way similar to active life
    ///
    /// - Parameters:
    ///   - time: start time for all actionalbes
    ///   - actionables: the actinalbes
    /// - Returns: array with associated starting ties
    /// - Throws: core data exception
    func calculateStartingTimesForActiveLife(forTime time: Date, actionables:[Actionable]) throws -> [(Actionable, ActionableTimeInfo)] {
        assert(actionables.first(where: { $0.type == .habit}) == nil, "there only tasks allowed")
        
        var startingTimes = [(Actionable, ActionableTimeInfo)]()
        var startingTimeOfTask = time

        for actionable in actionables {
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
            startingTimes.append((actionable, startingTimeInfo))
        }
        
        return startingTimes
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
