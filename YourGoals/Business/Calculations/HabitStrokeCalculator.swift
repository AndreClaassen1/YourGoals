//
//  HabitStrokeCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 10.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

class HabitStrokeCalculator {
    /// very inefficient way to calculate a stroke count for a habit
    ///
    /// - Parameters:
    ///   - habit: the habit
    ///   - date: the date to test
    /// - Returns: the stroke count
    func calculateStrokeCount(forHabit habit:Habit, andDate date: Date) -> Int {
        var strokeCount = 0
        var strokeDate = date
        while habit.isChecked(forDate: strokeDate) {
            strokeCount += 1
            strokeDate = strokeDate.addDaysToDate(-1)
        }
        
        return strokeCount
    }
}
