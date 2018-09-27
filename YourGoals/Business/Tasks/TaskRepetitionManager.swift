//
//  TaskRepetitionManager.swift
//  YourGoals
//
//  Created by André Claaßen on 23.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// utility class for updating the state of repetition tasks
class TaskRepetitionManager : StorageManagerWorker {
    
    /// this function sets the state of open for a task with a repetition
    /// if this task is due for today and wasn't closed for today
    ///
    /// - Parameter date: update the repetitions for date
    /// - Throws: core data exception
    func updateRepetitionState(forDate date:Date) throws {
        let date = date.day()
        let repetitionForDate = ActionableRepetition.repetitionForDate(date: date)
        
        // select all tasks which are done, where the done date != today
        let progress = try self.manager.tasksStore.fetchItems(qualifyRequest: {
            $0.predicate = NSPredicate(format: "state == 1 AND doneDate < %@ AND repetitionValue CONTAINS[cd] %@",
                                       date as NSDate,
                                       repetitionForDate.rawValue)
        })
        for t in progress {
            t.setTaskState(state: .active)
            t.doneDate = nil
        }
        
        try self.manager.saveContext()
    }
}
