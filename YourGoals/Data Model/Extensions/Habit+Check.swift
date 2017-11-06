//
//  Habit+Check.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

enum HabitCheckedState {
    case checked
    case notChecked
}

extension Habit {
    
    func allHabitChecks() -> [HabitCheck] {
        guard let checks = self.checks?.allObjects as? [HabitCheck] else {
            return []
        }
        
        return checks
    }
    
    /// very inperformant way to get check states
    ///
    /// - Returns: all check states as a hash
    func allChecks() -> [Date:Bool] {
        let checks = self.allHabitChecks()
        
        var hash = [Date:Bool]()
        
        for habitCheck in checks {
            if let date = habitCheck.check {
                hash[date] = true
            }
        }
        
        return hash
    }
    

    /// true, if habit is checked for date
    ///
    /// - Parameter date: the date
    func isChecked(forDate date: Date) -> Bool {
        return self.allChecks()[date.day()] ?? false
    }
}
