//
//  Tasks+State.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation



// MARK: - task state handling
extension Task {

    /// change the task state to active or done
    ///
    /// - Parameter state: active or done
    func setTaskState(state:ActionableState) {
        self.state = Int16(state.rawValue)
    }
    
    /// retrieve the state of the task
    ///
    /// - Returns: a task state
    func getTaskState() -> ActionableState {
        return ActionableState(rawValue: Int(self.state))!
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
