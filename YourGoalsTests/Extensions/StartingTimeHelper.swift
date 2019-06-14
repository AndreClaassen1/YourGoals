//
//  StartingTimeHelper.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 13.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

extension StartingTimeInfo {
    /// convinience constructor for unit testing
    ///
    /// - Parameters:
    ///   - hour: starting time hour
    ///   - minute: starting time minute
    ///   - second: starting time second
    ///   - remainingMinutes: estimated remaining time of action in minutes
    ///   - inDanger: true, if starting time is in danger
    ///   - fixed: true, if it is a fixed actionable
    init(hour:Int, minute: Int, second: Int, remainingMinutes: Double, inDanger: Bool, fixed: Bool) {
        let time = Date.timeWith(hour: hour, minute: minute, second: second)
        let inDanger = inDanger
        self.init(start: time, remainingTimeInterval: remainingMinutes * 60.0, inDanger: inDanger, fixed: fixed)
    }
}

