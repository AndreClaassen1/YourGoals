//
//  Goal+Date.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Goal {
    
    func logicalDateRange(forDate date: Date) -> (start: Date, end: Date) {
        if self.goalType() == .todayGoal {
            return logicalDateRangeForToday(date: date)
        }
        
        return (start: self.startDate ?? Date.minimalDate, end: self.targetDate ?? Date.maximalDate)
    }
    
    func logicalDateRangeForToday(date: Date) -> (start: Date, end: Date)  {
        let startInterval:TimeInterval = 60.0 * 60.0 * 8.0 // 8am
        let endInterval:TimeInterval = 60.0 * 60.0 * 20.00
        let date = date.day()
        
        return (start: date.addingTimeInterval(startInterval), end: date.addingTimeInterval(endInterval))
    }
    
}
