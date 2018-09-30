//
//  TaskProgressCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 27.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// calculates the progress
class TaskProgressCalculator {
    
    /// calculate the progress for a date as a percentage relative to the goal
    ///
    ///    - the size of each task will be used as a baseline for calculating
    ///    - overwork for a task will not be recognized.
    ///
    /// - Parameters:
    ///   - taskProgress: the progress
    ///   - date: reference date of the progress
    ///
    /// - Returns: progress between 0.0 and 1.0
    func calculateProgressOnGoal(taskProgress: TaskProgress, forDate date:Date) -> Double {
        guard let task = taskProgress.task else {
            NSLog("progress without task: \(taskProgress)")
            return 0.0
        }
        
        
        guard let goal = taskProgress.task?.goal else {
            NSLog("the task progress has no goal: \(taskProgress)")
            return 0.0
        }
        
        guard let tasks = taskProgress.task?.goal?.allTasks() else {
            NSLog("illegal goal task conflict. no tasks found \(goal)")
            return 0.0
        }
        
        let sizeOfGoal = tasks.reduce(TimeInterval(0)) { (s, task) -> TimeInterval in
            return s + TimeInterval(task.size * 60.0)
        }
        
        guard sizeOfGoal > 0 else {
            NSLog("illegal value for number of tasks: \(sizeOfGoal)")
            return 0.0
        }

        // overwork on a task will not be recognized.
        let timeWorkedOnTask = min(taskProgress.timeInterval(on: date), task.taskSizeAsInterval())
        let progressMadeOnGoal = timeWorkedOnTask / sizeOfGoal
        guard progressMadeOnGoal <= 1.0 else {
            return 1.0
        }
        
        return progressMadeOnGoal
    }
}
