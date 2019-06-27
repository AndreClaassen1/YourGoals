//
//  Date+Timeformat.swift
//  YourGoals
//
//  Created by André Claaßen on 08.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

extension Date {
    
    /// a string representation of the time without the date
    ///
    /// - Parameter locale: an optional locale
    /// - Returns: the formatted time as a string
    public func formattedTime(locale: Locale? = nil) -> String {
        return DateFormatter.createShortTimeFormatter(locale: locale).string(from: self)
    }
}
