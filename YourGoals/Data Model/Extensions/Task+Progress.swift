//
//  Tasks+Progress.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

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
        return self.allProgress().first { $0.isIntersecting(withDate: date) }
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
    func calcProgressDuration(atDate date:Date) -> TimeInterval {
        var progression = TimeInterval(0)
        
        for progress in self.allProgress() {
            progression += progress.timeInterval(til: date)
        }
        
        return progression
    }
}
