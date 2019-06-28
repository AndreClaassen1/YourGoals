//
//  StartingTimeInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 22.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation

/// a calculated time info with starting, end time and an indicator if this time is in a conflicting state
struct ActionableTimeInfo:Equatable {
    /// state of this item
    ///
    /// - active: active state
    /// - done: done state
    /// - progress: progress state
    enum State {
        case active
        case done
        case progress
    }

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
    
    let actionable:Actionable
    
    let progress:TaskProgress?
    
    static func == (lhs: ActionableTimeInfo, rhs: ActionableTimeInfo) -> Bool {
        return
            lhs.startingTime == rhs.startingTime &&
            lhs.remainingTimeInterval == rhs.remainingTimeInterval &&
            lhs.actionable.name == rhs.actionable.name
    }

    /// initalize this time info
    ///
    /// - Parameters:
    ///   - start: starting time
    ///   - remainingTimeInterval: remaining time
    ///   - conflicting: actionable is conflicting with another actionable
    ///   - fixed: indicator if starting time is fixed
    init(start:Date, end:Date, remainingTimeInterval:TimeInterval, conflicting: Bool, fixed: Bool, actionable: Actionable, progress: TaskProgress? = nil) {
        self.startingTime = start.extractTime()
        self.endingTime = end.extractTime()
        self.remainingTimeInterval = remainingTimeInterval
        self.conflicting = conflicting
        self.fixedStartingTime = fixed
        self.actionable = actionable
        self.progress = progress
    }
}
