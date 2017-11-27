//
//  Goal+Date.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

fileprivate let startOfWork:Double = 08.00
fileprivate let endOfWork:Double = 20.00

extension Goal {
    
    func logicalDateRange(forDate date: Date) -> (start: Date, end: Date) {
        if self.goalType() == .todayGoal {
            return logicalDateRangeForToday(date: date)
        }
        
        return (start: self.startDate ?? Date.minimalDate, end: self.targetDate ?? Date.maximalDate)
    }
    
    func logicalDateRangeForToday(date: Date) -> (start: Date, end: Date)  {
        let startInterval:TimeInterval = 60.0 * 60.0 * startOfWork // 8am
        let endInterval:TimeInterval = 60.0 * 60.0 * endOfWork
        let date = date.day()
        
        return (start: date.addingTimeInterval(startInterval), end: date.addingTimeInterval(endInterval))
    }
}
