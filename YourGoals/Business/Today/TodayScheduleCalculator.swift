//
//  TodayTableCellCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 11.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

struct StartingTimeInfo {
    let startingTime:Date
    let startingTimeInDanger:Bool
}

/// class for calculating starting times
class TodayScheduleCalculator:StorageManagerWorker {
    
    /// calculate the starting times relative to the given time for the actionables.
    ///
    /// - Parameters:
    ///   - time: start time for all actionalbes
    ///   - actionables: the actinalbes
    /// - Returns: array with associated starting ties
    /// - Throws: core data exception
    func calculateStartingTimes(forTime time: Date, actionables:[Actionable]) throws -> [StartingTimeInfo] {
        assert(actionables.first(where: { $0.type == .habit}) == nil, "there only tasks allowed")

        var startingTimes = [StartingTimeInfo]()
        var startTime = try calcStartTimeRelativeToActiveTasks(forTime: time)
        
        for actionable in actionables {
            if actionable.isProgressing(atDate: time) {
                if let task = actionable as? Task, let progress = task.progressFor(date: time), let start = progress.start {
                    startingTimes.append(StartingTimeInfo(startingTime: start, startingTimeInDanger: false))
                } else {
                    startingTimes.append(StartingTimeInfo(startingTime: time, startingTimeInDanger: false))
                }
            } else {
                startingTimes.append(StartingTimeInfo(startingTime: startTime, startingTimeInDanger: false))
                startTime.addTimeInterval(actionable.calcRemainingTimeInterval(atDate: startTime))
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
