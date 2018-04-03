//
//  NSDateExtensions.swift
//  YourDay
//
//  Created by André Claaßen on 02.01.15.
//  Copyright (c) 2015 Andre Claaßen. All rights reserved.
//

import Foundation


extension Date {
    public static func dateWithYear(_ year:Int, month:Int, day:Int) -> Date {
        return dateTimeWithYear(year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    
    public static let minimalDate = Date.dateWithYear(1900, month: 1, day: 1)
    public static let maximalDate = Date.dateWithYear(9999, month: 12, day: 31)
    
    public static func dateTimeWithYear(_ year:Int, month:Int, day:Int, hour:Int, minute:Int, second:Int, timezoneIdentifier:String? = nil) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = 0
        components.timeZone = timezoneIdentifier == nil ? TimeZone.current : TimeZone(identifier: timezoneIdentifier!)
        return calendar.date(from: components)!
    }
    
    
    public static func timeFromMinutes(_ minutes:Double) -> Date {
        return timeWith(0, minute: Int(minutes), second: 0)
    }
    
    public func extractTime() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute, .second],
            from: self)
        
        components.year = 2000
        components.month = 1
        components.day = 1
        components.nanosecond = 0
        components.timeZone = TimeZone.current
        return calendar.date(from: components)!
    }
    
    public static func timeWith(_ hour:Int, minute:Int, second:Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = 0
        components.timeZone = TimeZone.current
        return calendar.date(from: components)!
    }
    
    public func addDaysToDate(_ numberOfDays: Int) -> Date {
        let addedDate = Calendar.current.date(byAdding: Calendar.Component.day, value: numberOfDays, to: self)
        return addedDate!
    }
    
    /// add some minutes to a date
    ///
    /// - Parameter numberOfMinutes: number of minutes
    /// - Returns: the new date
    public func addMinutesToDate(_ numberOfMinutes: Int) -> Date {
        return Calendar.current.date(byAdding: Calendar.Component.minute , value: numberOfMinutes, to: self)!
    }
    
    /// extract only the day for the datetime
    ///
    /// - Returns: day.
    public func day() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .month, .year], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        
        return calendar.date(from: components)!
    }
    
    public func convertToMinutes() -> Double {
        let minutes = self.timeIntervalSince(Date.timeWith(0, minute: 0, second: 0)) / 60.0
        return minutes
    }
}
