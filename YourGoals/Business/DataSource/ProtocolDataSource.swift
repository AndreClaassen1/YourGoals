//
//  ProtocolDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// progress on a goal for a given date
struct ProtocolGoalInfo {
    let goal:Goal
    let workedOnGoal:TimeInterval
    let date:Date
    
    init(goal: Goal, date:Date) {
        self.goal = goal
        self.date = date
        workedOnGoal = 0
    }
}

/// progress on a task for a given date
protocol ProtocolProgressInfo {
    var title:String { get }
    var timeRange:String { get }
    var description:String { get }
}

struct TaskProgressInfo:ProtocolProgressInfo {
    let progress:TaskProgress
    
    var timeRange: String {
        return "0:00 - 0:00"
    }
    
    var description: String {
        return "Du bist deinem Ziel 3% näher gekommen!"
    }
    
    var title: String {
        return self.progress.task?.name ?? "Kein Task bekannt"
    }
    
    init(progress: TaskProgress) {
        self.progress = progress
    }
}

struct HabitProgressInfo:ProtocolProgressInfo {
    var title: String
    
    var timeRange: String
    
    var description: String

}

/// a data source for providing a protocol info
class ProtocolDataSource : StorageManagerWorker {
    
    /// fetch all goal worked on the given day
    ///
    /// - Parameter date: the date
    /// - Returns: array of ProtocolGoalInfo
    /// - Throws: a core data exception
    func fetchWorkedGoals(forDate date: Date) throws -> [ProtocolGoalInfo] {
        let startOfDay = date.startOfDay
        let endOfDay = date.endOfDay
        
        let progressGoals = try self.manager.goalsStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format:
                "SUBQUERY(tasks, $t, " +
                    "SUBQUERY($t.progress, $progress, $progress.start >= %@ AND $progress.end <= %@).@count > 0" +
                ").@count > 0",
                startOfDay as NSDate, endOfDay as NSDate)
        }).map { ProtocolGoalInfo(goal: $0, date: date) }
        
        return progressGoals
    }
    
    /// fetch progress items for a goal for the given date
    ///
    /// - Parameters
    ///   - goalInfo: the goal info structiore
    /// - Returns: an array of Protocol Progress Info Items
    /// - Throws: Core Data Exception
    func fetchProgressOnGoal(goalInfo: ProtocolGoalInfo) throws -> [ProtocolProgressInfo] {
        let startOfDay = goalInfo.date.startOfDay
        let endOfDay = goalInfo.date.endOfDay
        let progress = try self.manager.taskProgressStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format: "task.goal = %@ && start >= %@ AND end <= %@", goalInfo.goal, startOfDay as NSDate, endOfDay as NSDate)
        }).map { TaskProgressInfo(progress: $0) }
    
        return progress
    }
}
