//
//  TodayTableCellCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 11.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// a calculated starting time with an indicator when the starting time is in danger
struct StartingTimeInfo:Equatable {
    
    /// the estimated starting time (not date) of an actionable
    let startingTime:Date
    
    /// the estimated ending time
    let endingTime:Date
    
    /// the remaining time left for the task as a timeinterval
    let remainingTimeInterval:TimeInterval
    
    /// the start of this time is in danger cause of the previous task is being late
    let conflicting: Bool
    
    /// indicator, if the starting time is fixed
    let fixedStartingTime: Bool
    
    /// initalize this time info
    ///
    /// - Parameters:
    ///   - start: starting time
    ///   - remainingTimeInterval: remaining time
    ///   - conflicting: actionable is conflicting with another actionable
    ///   - fixed: indicator if starting time is fixed
    init(start:Date, end:Date, remainingTimeInterval:TimeInterval, conflicting: Bool, fixed: Bool) {
        self.startingTime = start.extractTime()
        self.endingTime = end.extractTime()
        self.remainingTimeInterval = remainingTimeInterval
        self.conflicting = conflicting
        self.fixedStartingTime = fixed
    }
}

/// class for calculating starting times
class TodayScheduleCalculator:StorageManagerWorker {
    
    /// calculate the starting times drelative to the given time for the actionables.
    ///
    /// - Parameters:
    ///   - time: start time for all actionalbes
    ///   - actionables: the actinalbes
    /// - Returns: array with associated starting ties
    /// - Throws: core data exception
    func calculateStartingTimes(forTime time: Date, actionables:[Actionable]) throws -> [StartingTimeInfo] {
        assert(actionables.first(where: { $0.type == .habit}) == nil, "there only tasks allowed")

        var startingTimes = [StartingTimeInfo]()
        var startTime = try calcStartTimeRelativeToActiveTasks(forTime: time).extractTime()
        
        for actionable in actionables {
            
            if actionable.isProgressing(atDate: time) {
                let remainingTime = actionable.calcRemainingTimeInterval(atDate: time)
                if let task = actionable as? Task, let progress = task.progressFor(date: time), let start = progress.start {
                    startingTimes.append(StartingTimeInfo(start: start, end: time.addingTimeInterval(remainingTime), remainingTimeInterval: remainingTime, conflicting: false, fixed: false))
                } else {
                    startingTimes.append(StartingTimeInfo(start: time, end: time.addingTimeInterval(remainingTime), remainingTimeInterval: remainingTime, conflicting: false, fixed: false))
                }
            } else {
                var conflicting = false
                var fixed = false
                if let beginTime = actionable.beginTime {
                    conflicting = startTime.compare(beginTime) == .orderedDescending
                    startTime = beginTime
                    fixed = true
                }
                let remainingTime = actionable.calcRemainingTimeInterval(atDate: startTime)
                startingTimes.append(StartingTimeInfo(start: startTime, end: startTime.addingTimeInterval(remainingTime), remainingTimeInterval: remainingTime, conflicting: conflicting, fixed: fixed))
                startTime.addTimeInterval(remainingTime)
            }
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
