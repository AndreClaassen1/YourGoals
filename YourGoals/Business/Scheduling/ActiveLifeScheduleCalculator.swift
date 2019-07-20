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
        self.estimatedLength = TimeInterval(0)
        self.conflicting = false
        self.fixedStartingTime = false
        self.actionable = actionable
        self.progress = progress
    }
}

extension Actionable {
    
    /// fetch all done progress items fromt the task and create time infos out of them
    ///
    /// - Parameters:
    ///   - actionable: the task
    ///   - day: the day
    /// - Returns: an array of time infos from the done task progress records
    func timeInfosFromDoneProgress(forDay day:Date) -> [ActionableTimeInfo] {
        guard let task = self as? Task else {
            return []
        }
        
        let day = day.day()
        
        let timeInfos = task
            .progressFor(day: day)
            .filter{ $0.state == .done }
            .map{ ActionableTimeInfo(day: day, actionable: self, progress: $0) }
            .sorted { $0.startingTime.compare($1.startingTime) == .orderedAscending  }
        return timeInfos
    }
}

/// class for calculating starting times for the active life view
class ActiveLifeScheduleCalculator:StorageManagerWorker {
    
    /// calculate the correct starting time for an actionable
    ///
    /// - Parameters:
    ///   - time: actual system time
    ///   - actionable: the actionable
    /// - Returns: the starting time
    func calculateStartingTime(forTime time:Date, actionable: Actionable) -> Date {
        if let task = actionable as? Task, let progress = task.progressFor(date: time), let progressStart = progress.start {
            return progressStart
        }
        
        if let beginTime = actionable.beginTime {
            return beginTime
        }
        
        return time
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
            let task = actionable as! Task
            timeInfos.append(contentsOf: actionable.timeInfosFromDoneProgress(forDay: time))
            
            // if this actionable is done, leave the loop
            if actionable.checkedState(forDate: time) == .done {
                // let timeInfo = ActionableTimeInfo(start: actionable.)
                
                if let doneDate = task.doneDate {
                    let timeInfo = ActionableTimeInfo(start: doneDate, end: doneDate, remainingTimeInterval: 0, conflicting: false, fixed: false, actionable: task)
                    
                    timeInfos.append(timeInfo)
                } else {
                    NSLog("warning: no done date set in done task: \(task)")
                }
            
                continue
            }
            
            // calculate next starting time of done items
            startingTimeOfTask = timeInfos.reduce(startingTimeOfTask) {
                let nextStartingTime = $1.endingTime // start is one second later than ending
                return $0.compare(nextStartingTime) == .orderedAscending ? nextStartingTime: $0
            }
            
            
            let startingTimeForActionable = calculateStartingTime(forTime: startingTimeOfTask, actionable: actionable)
            let conflicting = startingTimeForActionable.compare(startingTimeOfTask) == .orderedAscending
            let fixed = actionable.beginTime != nil
            let remainingTime = actionable.calcRemainingTimeInterval(atDate: startingTimeForActionable)
            let endingTimeForTask = startingTimeForActionable.addingTimeInterval(remainingTime)
            
            let timeInfo = ActionableTimeInfo(start: startingTimeForActionable, end: endingTimeForTask, remainingTimeInterval: remainingTime,
                                                  conflicting: conflicting, fixed: fixed, actionable: actionable)
            timeInfos.append(timeInfo)
            startingTimeOfTask = endingTimeForTask
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
