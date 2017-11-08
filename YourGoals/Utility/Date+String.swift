//
//  Date+String.swift
//  YourGoals
//
//  Created by André Claaßen on 08.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Date {
    
    /// format a date in short locale format
    ///
    /// - Returns: a string representation
    public func formattedInLocaleFormat() -> String {
        let formattedDate = DateFormatter.createShortDateTimeFormatter().string(from: self)
        return formattedDate
    }
    
    /// get the current day in locale format except if it is today, yesterday or tomorrow
    /// in those cases a nice string will this text will be returned
    ///
    /// - Parameter date: a date
    /// - Returns: a formatted string or today, yesterday, tomorrow
    public func formattedWithTodayTommorrowYesterday() -> String {
        let date = self.day()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return NSLocalizedString("Today", comment: "today")
        }
        
        if calendar.isDateInTomorrow(date) {
            return NSLocalizedString("Tomorrow", comment: "tomorrow")
        }
        
        if calendar.isDateInYesterday(date) {
            return NSLocalizedString("Yesterday", comment: "yesterday")
        }
        
        return date.formattedInLocaleFormat()
    }
}
