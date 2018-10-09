//
//  Tasks+Progress.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension Task {
    
    /// give me access to all progress of objects associated with this dask
    ///
    /// - Returns: an array of task progress objects
    func allProgress() -> [TaskProgress] {
        return self.progress?.allObjects as? [TaskProgress] ?? []
    }
    
    /// get progress for the date/time if available
    ///
    /// - Parameter date: date
    /// - Returns: a TaskProgress or nil
    func progressFor(date: Date) -> TaskProgress? {
        return self.allProgress().first { $0.intersects(withDate: date) }
    }
    
    /// true, if this task is in progress
    ///
    /// - Parameter date: date to test
    /// - Returns: true if it is in progress
    func isProgressing(atDate date: Date) -> Bool {
        return self.progressFor(date: date) != nil
    }
    
    /// calculate the absolute progression as a timeIntervall
    ///
    /// - Parameter date: calculate til date
    /// - Returns: the progression as a time interval
    func calcProgressDuration(atDate date:Date) -> TimeInterval? {
        var progression = TimeInterval(0)
        
        if self.allProgress().count == 0 {
            return nil
        }
        
        for progress in self.allProgress() {
            progression += progress.timeInterval(til: date)
        }
        
        return progression
    }
    
    // Mark: - Calculate remaining time for the task

    /// calculate the task size as a timeinterval (task size in seconds)
    ///
    /// - Returns: task size as a time interval
    func taskSizeAsInterval() -> TimeInterval {
        return TimeInterval(self.size * 60.0)
    }
    
    /// calculates the remaining time for the task based on the size of the time in minutes and the progress
    ///
    /// - Parameter date: the date for the calculation
    /// - Returns: the remaining time as a time interval (time in seconds)
    func calcRemainingTimeInterval(atDate date:Date) -> TimeInterval {
        let progression = self.calcProgressDuration(atDate: date) ?? TimeInterval(0.0)
        let remainingTime = taskSizeAsInterval() - progression
        if remainingTime < 0.0 {
            return 0.0
        }
        return remainingTime
    }
    
    func calcRemainingPercentage(atDate date: Date) -> Double {
        if taskSizeAsInterval() == 0.0 {
            return 0.0
        }
        
        let percentage = calcRemainingTimeInterval(atDate: date) / taskSizeAsInterval()
        
        return percentage < 0.0 ? 0.0 : (percentage > 1.0 ? 1.0 : percentage)
    }
}
