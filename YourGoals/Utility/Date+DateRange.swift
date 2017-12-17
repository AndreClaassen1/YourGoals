//
//  Date+DateRange.swift
//  YourGoals
//
//  Created by André Claaßen on 17.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

// this extension is based on ideas of
// http://adampreble.net/blog/2014/09/iterating-over-range-of-dates-swift/
extension Calendar {
    
    /// create a range from start date to end date. default is stepping a day with interval 1
    ///
    /// - Parameters:
    ///   - startDate: start date
    ///   - endDate: end date
    ///   - stepUnits: step in days
    ///   - stepValue: 1
    /// - Returns: a range
    func dateRange(startDate: Date, endDate: Date, stepComponent: Calendar.Component = .day, stepValue: Int = 1) -> DateRange {
        let dateRange = DateRange(calendar: self, startDate: startDate, endDate: endDate,
                                  stepComponent: stepComponent, stepValue: stepValue, multiplier: 0)
        return dateRange
    }
    
    /// create a range of dates with a start date and a number of steps (eg. days)
    ///
    /// - Parameters:
    ///   - startDate: start date of the range
    ///   - steps: number of steps
    ///   - stepComponent: component eg. day
    ///   - stepValue: increment
    /// - Returns: a daterange of nil
    func dateRange(startDate: Date, steps:Int, stepComponent: Calendar.Component = .day, stepValue: Int = 1) -> DateRange? {
        guard let endDate = self.date(byAdding: stepComponent, value: stepValue * steps, to: startDate) else {
            return nil
        }
        
        let dateRange = DateRange(calendar: self, startDate: startDate, endDate: endDate,
                                  stepComponent: stepComponent, stepValue: stepValue, multiplier: 0)
        return dateRange
    }
}

/// the date range is sequence for iterating easier over a range of dates
struct DateRange:Sequence {
    
    var calendar: Calendar
    var startDate: Date
    var endDate: Date
    var stepComponent: Calendar.Component
    var stepValue: Int
    fileprivate var multiplier: Int

    // MARK: - Sequence Protocol
    
    func makeIterator() -> DateRange.Iterator {
        return Iterator(range: self)
    }
    
    // Mark: - Iterator
    
    struct Iterator: IteratorProtocol {
        
        var range: DateRange
        
        mutating func next() -> Date? {
            
            guard let nextDate = range.calendar.date(byAdding: Calendar.Component.day, value: range.stepValue * range.multiplier, to: range.startDate) else {
                return nil
            }
            
            if nextDate > range.endDate {
                return nil
            }
            else {
                range.multiplier += 1
                return nextDate
            }
        }
    }
}
