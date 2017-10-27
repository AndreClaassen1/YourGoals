//
//  Tasks+Statwe.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// task states
///
/// - active: the task is active
/// - done: task is done
enum TaskState:Int16 {
    case active = 0
    case done = 1
}

// MARK: - task state handling
extension Task {

    /// change the task state to active or done
    ///
    /// - Parameter state: active or done
    func setTaskState(state:TaskState) {
        self.state = state.rawValue
    }
    
    /// retrieve the state of the task
    ///
    /// - Returns: a task state
    func getTaskState() -> TaskState {
        return TaskState(rawValue: self.state)!
    }
    
    /// true, if task is active
    ///
    /// - Returns: true, if task is active
    func taskIsActive() -> Bool {
        return getTaskState() == .active
    }
    
    /// true, if task is done
    ///
    /// - Returns: true if task is done
    func taskIsDone() -> Bool {
        return getTaskState() == .done
    }
}
