//
//  Task+Committing.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

enum CommittingState {
    case notCommitted
    case committedForDate
    case committedForPast
    case committedForFuture
}

extension Task {
    
    /// check the commitment state of a task. is it a commitment for day or is the commitment pas?
    ///
    /// *Important*: Commitment past is for a commitment you have failed. the state is active
    ///              but the commitment date has past. Future commitments will be ignored
    ///
    /// - Parameter date: check for this date
    /// - Returns: commitment state
    func committingState(forDate date:Date) -> CommittingState {
        let dayOfDate = date.day()
        
        guard let commitmentDate = self.commitmentDate?.day() else {
            return .notCommitted
        }
        
        if commitmentDate.compare(dayOfDate) == .orderedSame {
            return .committedForDate
        }
        
        if commitmentDate.compare(dayOfDate) == .orderedAscending &&
            self.getTaskState() == .active {
            return .committedForPast
        }
        
        if commitmentDate.compare(dayOfDate) == .orderedDescending {
            return .committedForFuture
        }
        
        return .notCommitted
    }
}
