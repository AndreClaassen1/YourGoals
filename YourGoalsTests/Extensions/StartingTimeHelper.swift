//
//  StartingTimeHelper.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 13.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

extension ActionableTimeInfo {
    /// convinience constructor for unit testing
    ///
    /// - Parameters:
    ///   - hour: starting time hour
    ///   - minute: starting time minute
    ///   - second: starting time second
    ///   - remainingMinutes: estimated remaining time of action in minutes
    ///   - conflicting: true, if starting time is in danger
    ///   - fixed: true, if it is a fixed actionable
    init(hour:Int, minute: Int, second: Int,
         end: Date? = nil, remainingMinutes: Double, conflicting: Bool, fixed: Bool, actionable: Actionable) {
        let time = Date.timeWith(hour: hour, minute: minute, second: second)
        let end = end ?? time.addingTimeInterval(remainingMinutes * 60.0)
        self.init(start: time, end: end, remainingTimeInterval: remainingMinutes * 60.0, conflicting: conflicting, fixed: fixed, actionable: actionable)
    }
}

