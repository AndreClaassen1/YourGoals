//
//  Date+startendofday.swift
//  YourGoals
//
//  Created by André Claaßen on 26.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

extension Date {
    
    var startOfDay:Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay:Date {
        return startOfDay.addDaysToDate(1).addingTimeInterval(-1)
    }
    
    /// an interval spanning the whole day from start to end.
    var dayInterval:DateInterval {
        return DateInterval(start: self.startOfDay, end: self.endOfDay)
    }
}
