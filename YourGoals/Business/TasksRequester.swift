//
//  TasksRequester.swift
//  YourGoals
//
//  Created by André Claaßen on 04.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class TasksRequester : StorageManagerWorker {
    
    /// is there any active task, which isn't a commtted task?
    ///
    /// This request is nesseccary to decide, if you should see the active tasks pane
    ///
    /// - Parameter date: date
    /// - Returns: true, if there are active tasks which aren't committed
    ///            false, if there are no active tasks or all active tasks are committed
    func areThereActiveTasksWhichAreNotCommitted(forDate date: Date) throws -> Bool {
        let activeTasks =  try TaskProgressManager(manager: self.manager).activeTasks(forDate: date)
        guard activeTasks.count > 0 else {
            return false
        }
        
        let tasksNotCommitted = activeTasks.filter{ $0.committingState(forDate: date) != .committedForDate }
        return tasksNotCommitted.count > 0
    }
}
