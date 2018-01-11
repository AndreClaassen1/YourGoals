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
    
    static func createShortTimeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter
    }
}
