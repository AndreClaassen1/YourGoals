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
    var timeRange: String
    var description: String
    var title: String
    let task:Task
    let percentageReached:Double
    let progress:Progress
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
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = startOfDay.addDaysToDate(1).addingTimeInterval(-1)
        
        let progressGoals = try self.manager.goalsStore.fetchItems(qualifyRequest: { request in
            request.predicate = NSPredicate(format:
                "SUBQUERY(tasks, $t, " +
                    "SUBQUERY($t.progress, $progress, $progress.start >= %@ AND $progress.end <= %@).@count > 0" +
                ").@count > 0",
                startOfDay as NSDate, endOfDay as NSDate)
        }).map { ProtocolGoalInfo(goal: $0, date: date) }
        
        return progressGoals
    }
    
    func fetchProgresysOnGoal(goalInfo: ProtocolGoalInfo) -> [ProtocolProgressInfo] {
        return []
    }
}
