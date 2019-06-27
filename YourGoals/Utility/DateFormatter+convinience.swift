//
//  DateFormatter.swift
//  YourGoals
//
//  Created by André Claaßen on 08.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// create a formatter for a date without a time
    ///
    /// - Returns: date formatter
    static func createShortDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter
    }
    
    /// create a formattter for a time without a date
    ///
    /// - Returns: a date formatter for producing or consuming a time string
    static func createShortTimeFormatter(locale: Locale? = nil) -> DateFormatter {
        let dateFormatter = DateFormatter()
        if let locale = locale {
            dateFormatter.locale = locale
        }
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter
    }
    
    /// create a time from a standard formatted time string
    ///
    /// - Parameter timeStr: the time string
    /// - Returns: a date with a time if a time str was available
    static func timeFromShortTimeFormatted(timeStr: String, locale: Locale?) -> Date? {
        let dateFormatter = createShortTimeFormatter()
        if let locale = locale {
            dateFormatter.locale = locale
        }
        let time = dateFormatter.date(from: timeStr)
        return time
    }
}
