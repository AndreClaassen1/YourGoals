//
//  AppBadgeCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 24.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class AppBadgeCalculator {
    
    let todayActionablesDataSource:TodayAllActionablesDataSource
    
    init(manager:GoalsStorageManager) {
        self.todayActionablesDataSource = TodayAllActionablesDataSource(manager: manager)
    }
    
    /// calculate the number of active actionables for the given date
    ///
    /// - Parameter date: the date
    /// - Returns: number of active actionables. unchecked tasks plus unchecked habits
    /// - Throws: a core data exception
    func numberOfActiveActionables(forDate date: Date) throws -> NSNumber {
        let actionables = try self.todayActionablesDataSource.fetchActionables(forDate: date, andSection: nil)
        let numberOfActiveActionables = actionables.reduce(0) {
            $0 + (($1.checkedState(forDate: date) == .active) ? 1 : 0)
        }
        return NSNumber(value: numberOfActiveActionables)
    }
}
