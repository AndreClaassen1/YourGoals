//
//  GoalProgressCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// progress indicator
///
/// - met: 95% - 100%
/// - ahead: 20% more ahead
/// - onTrack: + / - 20%
/// - lagging: 20% behind
/// - behind: >50% behind
/// - notStarted: no progress at allo
enum ProgressIndicator {
    case met
    case ahead
    case onTrack
    case lagging
    case behind
    case notStarted
}

/// this class calculates the progress on this goal in percent
class GoalProgressCalculator {
    
    /// calculate the progress made on this goal. compare progress of tasks done versus progress of time elapsed
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - date: the date for comparision
    /// - Returns: progress of tasks in percent and a progress indicator
    func calculateProgress(forGoal goal: Goal, forDate date: Date) -> (progressInPercent:Double, indicator:ProgressIndicator) {
        let progressTasks = calculateProgressOfTasksInPercent(forGoal: goal)
        let progressDate = calculateProgressOfTimeInPercent(forGoal: goal, forDate: date)
        let progressIndicator = calculateIndicator(progressTasks: progressTasks, progressDate: progressDate)
        return (progressTasks, progressIndicator)
    }
    
    /// calculate the progress of tasks done in per
    ///
    /// - Parameter goal: the goal
    /// - Returns: ratio of done tasks and all tasks
    func calculateProgressOfTasksInPercent(forGoal goal: Goal) -> Double {
        let percent = Double(goal.numberOfTasks(forState: .done)) / Double(goal.allTasks().count)
        return percent
    }
    
    /// calculate the progress of time in relation to the given date
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - date: the date for calculate the progress of time since start of the goal
    /// - Returns: percentage of time elapsed from the goal
    func calculateProgressOfTimeInPercent(forGoal goal: Goal, forDate date:Date) -> Double {
        let startDate = goal.startDate ?? Date.minimalDate
        let endDate = goal.targetDate ?? Date.maximalDate
        
        let timeSpanGoal = endDate.timeIntervalSince(startDate)
        let timeSpanForDate = date.timeIntervalSince(startDate)
        
        let percent = timeSpanForDate / timeSpanGoal
        if percent < 0.0 {
            return 0.0
        }
        if percent > 1.0 {
            return 1.0
        }
        
        return percent
    }
    
    /// calculate an indicator of progress relative to the time of the goal
    ///
    /// - Parameters:
    ///   - progressTasks: progress of the tasks in percent
    ///   - progressDate: progress of the date in percent
    /// - Returns: an indicator
    func calculateIndicator(progressTasks:Double, progressDate: Double) -> ProgressIndicator {
        if progressTasks == 0.0 {
            return .notStarted
        }
        
        if progressTasks >= 0.95 {
            return .met
        }
        
        if progressTasks - progressDate >= 0.20 {
            return .ahead
        }
        
        if progressTasks - progressDate >= -0.20 {
            return .onTrack
        }
        
        if progressTasks - progressDate  >= -0.50 {
            return .lagging
        }
        
        return .behind
    }
    
}
