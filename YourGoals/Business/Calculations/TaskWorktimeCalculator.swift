//
//  TaskWorktimeCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 06.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// calculates the working time of a task.
class TaskWorktimeCalculator {
    
    /// calculate the sum of the worktime for the task on a date
    ///
    /// - Parameters:
    ///   - task: task
    ///   - date: date for calculation
    /// - Returns: worktime for a date
    func calculateWorktime(task: Task, date: Date) -> TimeInterval {
        
        // filter all progress for the given date
        let progressOnDate = task.allProgress().filter({
            $0.intersects(withInterval: date.dayInterval)
        })
        
        // sum all progress for the given date
        let worktime = progressOnDate.reduce(TimeInterval(0), {
            return $0 + $1.timeInterval(on: date)
        })
        
        return worktime
    }
}
