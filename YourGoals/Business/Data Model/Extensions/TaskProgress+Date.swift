//
//  TaskProgress+Date.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension TaskProgress {
    
    /// retrieves the task progress as an DateInterval
    var dateInterval:DateInterval {
        let startDate = self.start ?? Date.minimalDate
        let endDate = self.end ?? Date.maximalDate
        
        return DateInterval(start: startDate, end: endDate)
    }
    
    /// returns true, if there is an intersection between the two intervals
    ///
    /// - Parameter withInterval: the interval to compare with the time progress
    /// - Returns: true, if there is an intersection
    func intersects(withInterval: DateInterval) -> Bool {
        return self.dateInterval.intersects(withInterval)
    }

    /// true, if the date lies between start and end of the current progress
    ///
    /// - Parameter date: check this date
    /// - Returns: true, if the date intersects the current progress
    func intersects(withDate date: Date) -> Bool {
        
        let startDate = self.start ?? Date.minimalDate
        let endDate = self.end ?? Date.maximalDate
        
        return (startDate.compare(date) == ComparisonResult.orderedSame || startDate.compare(date) == ComparisonResult.orderedAscending) &&
            (endDate.compare(date) == ComparisonResult.orderedSame || endDate.compare(date) == ComparisonResult.orderedDescending)
    }
    
    /// calculate the time interval for a progression til date
    ///
    /// - Parameter date: time interval
    func timeInterval(til date:Date) -> TimeInterval {
        let startDate = self.start ?? Date.minimalDate
        let endDate = self.end ?? date
        
        let interval = endDate.timeIntervalSince(startDate)
        return interval >= 0 ? interval : TimeInterval(0)
    }
    
    /// start date and time for the given date
    ///
    /// - Parameter day: the day
    /// - Returns: a datetime in the range of the day
    func startOfDay(day: Date) -> Date {
         return min(max(day.startOfDay, self.start ?? day.startOfDay ), day.endOfDay)
    }

    /// end date and time for the given date
    ///
    /// - Parameter day: the day
    /// - Returns: a datetime in the range of the day
    func endOfDay(day: Date) -> Date {
        return max(day.startOfDay, min(day.endOfDay, self.end ?? day))
    }

    /// calculate the time interval worked on a given date
    ///
    /// - Parameter date: time interval
    func timeInterval(on date:Date) -> TimeInterval {
        let startDate = startOfDay(day: date)
        let endDate = endOfDay(day: date)
        
        let interval = endDate.timeIntervalSince(startDate)
        return interval >= 0 ? interval : TimeInterval(0)
    }
}
