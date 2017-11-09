//
//  Habit+Actionable.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

// MARK: - Actionable Extension for feeding the ActionableTableView and its cells
extension Habit:Actionable {
    
    /// .checked, if the habit is checked on the given date
    ///
    /// - Parameter date: the date
    /// - Returns: .checked if the habit has an entry on the given date
    func checkedState(forDate date: Date) -> ActionableState {
        return self.isChecked(forDate: date) ? .done : .active
    }
    
    /// habits havn't any progress for any given date
    ///
    /// - Parameter date: date
    /// - Returns: nil
    func calcProgressDuration(atDate date: Date) -> TimeInterval? {
        return nil
    }
    
    /// a habit is never progressing at any date
    ///
    /// - Parameter date: date
    /// - Returns: always false
    func isProgressing(atDate date: Date) -> Bool {
        return false
    }
    
    var commitmentDate:Date? { return nil }
    
    func committingState(forDate date:Date) -> CommittingState {
        return .notCommitted
    }
}
