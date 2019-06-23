//
//  StartingTimeInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 22.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation

/// a calculated starting time with an indicator when the starting time is in danger
struct StartingTimeInfo:Equatable {
    
    /// the estimated starting time (not date) of an actionable
    let startingTime:Date
    
    /// the estimated ending time
    let endingTime:Date
    
    /// the remaining time left for the task as a timeinterval
    let remainingTimeInterval:TimeInterval
    
    /// the start of this time is in danger cause of the previous task is being late
    let conflicting: Bool
    
    /// indicator, if the starting time is fixed
    let fixedStartingTime: Bool
    
    /// initalize this time info
    ///
    /// - Parameters:
    ///   - start: starting time
    ///   - remainingTimeInterval: remaining time
    ///   - conflicting: actionable is conflicting with another actionable
    ///   - fixed: indicator if starting time is fixed
    init(start:Date, end:Date, remainingTimeInterval:TimeInterval, conflicting: Bool, fixed: Bool) {
        self.startingTime = start.extractTime()
        self.endingTime = end.extractTime()
        self.remainingTimeInterval = remainingTimeInterval
        self.conflicting = conflicting
        self.fixedStartingTime = fixed
    }
}
