//
//  GoalWithProgress.swift
//  YourGoals
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Goal {
    
    /// a goal is active, if it has at least one task with progress on it.
    ///
    /// - Parameter date: date to test
    /// - Returns: true, if task is progressing
    func isActive(forDate date:Date) -> Bool {
        return allTasks().filter{ $0.isProgressing(atDate: date) }.count > 0
    }
    
}
