//
//  StartingTimeInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 22.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation

/// a calculated time info with starting, end time and an indicator if this time is in a conflicting state
struct ActionableTimeInfo:Equatable, ActionableItem {
    /// state of this item
    ///
    /// - open: the task is open but not progressing
    /// - progressing: the task is currently progressing
    /// - done: the task is done
    /// - progress: this is a done task progress entry
    enum State {
        case open
        case progressing
        case progress
        case done
        
        func asString() -> String {
            switch self {
            case .progress: return "Progress"
            case .progressing: return "Progressing"
            case .open: return "Open"
            case .done: return "Done"
            }
        }
    }

    /// the estimated starting time (not date) of an actionable
    let startingTime:Date
    
    /// the estimated ending time
    let endingTime:Date
    
    /// the estimated time left for the task as a timeinterval
    let estimatedLength:TimeInterval
    
    /// the start of this time is in danger cause of the previous task is being late
    let conflicting: Bool
    
    /// indicator, if the starting time is fixed
    let fixedStartingTime: Bool
    
    /// the actionable for this time info
    let actionable:Actionable
    
    /// an optional progress, if this time info is corresponding with a done task progress
    let progress:TaskProgress?
    
    /// calculate the state for the time info
    ///
    /// - Parameter forDate: the date/time for the calculating
    /// - Returns: a state
    func state(forDate date: Date) -> State {
        if progress != nil {
            return .progress
        }
        
        if actionable.isProgressing(atDate: date) {
            return .progressing
        }
        
        let actionableState = actionable.checkedState(forDate: date)
        switch actionableState {
        case .active:
            return .open
        case .done:
            return .done
        }
    }
    
    static func == (lhs: ActionableTimeInfo, rhs: ActionableTimeInfo) -> Bool {
        return
            lhs.startingTime == rhs.startingTime &&
            lhs.endingTime == rhs.endingTime &&
            lhs.estimatedLength == rhs.estimatedLength &&
            lhs.actionable.name == rhs.actionable.name
    }

    /// initalize this time info
    ///
    /// - Parameters:
    ///   - start: starting time
    ///   - estimatedLength: remaining time
    ///   - conflicting: actionable is conflicting with another actionable
    ///   - fixed: indicator if starting time is fixed
    init(start:Date, end:Date, remainingTimeInterval:TimeInterval, conflicting: Bool, fixed: Bool, actionable: Actionable, progress: TaskProgress? = nil) {
        self.startingTime = start.extractTime()
        self.endingTime = end.extractTime()
        self.estimatedLength = remainingTimeInterval
        self.conflicting = conflicting
        self.fixedStartingTime = fixed
        self.actionable = actionable
        self.progress = progress
    }
}
