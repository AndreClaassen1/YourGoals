//
//  TaskProgressCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 27.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// calculates the progress
class TaskProgressCalculator:StorageManagerWorker {
    
    let backburnedGoals: Bool
    
    init(manager: GoalsStorageManager, backburnedGoals: Bool) {
        self.backburnedGoals = backburnedGoals
        super.init(manager: manager)
    }
    
    /// calculate the tasks for the goal. for a today goal, all tasks from all
    /// goals, which are committed now or yesterday are valid.
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - date: the date
    /// - Returns: tasks for the today task
    func tasksForGoal(goal: Goal, andDate date: Date) throws -> [Task] {
        
        if goal.goalType() != .todayGoal {
            return goal.allTasks()
        }
        
        let taskManager = TaskCommitmentManager(manager: self.manager)
        let committedTasks = try taskManager.committedTasksTodayAndFromThePast(forDate: date, backburnedGoals: backburnedGoals)
        
        return committedTasks
    }
    
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

        do {
            let tasks = try tasksForGoal(goal: goal, andDate: date)
            
            
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
        catch let error {
            NSLog("couldn't calculate the tasks for this goal: \(goal)")
            return 0.0
        }
    }
}
