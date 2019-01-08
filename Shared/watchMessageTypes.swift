//
//  watchMessageTypes.swift
//  YourGoals
//
//  Created by André Claaßen on 10.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// a job request (action) from the watch to the app
///
/// - actionActualizeState: request a new watch application state
/// - actionNeedMoreTime: a task needs more time. request for increase the task time by 15 minutes
/// - actionDone: a task is done
/// - actionStopTask: a task should be paused
/// - actionAddTask: request adding a new task
/// - actionStartTask: start a task
enum WatchAction:String {
    case actionActualizeState
    case actionNeedMoreTime
    case actionDone
    case actionStopTask
    case actionAddTask
    case actionStartTask
}

struct WatchTaskInfo {
    let taskName:String
    let percentage:Double
    let remainingTime:TimeInterval
    let goalName:String
    let taskUri:String
    let isProgressing:Bool

    #if os(iOS)
    
    init(task: Task, date: Date) {
        self.percentage = task.calcRemainingPercentage(atDate: date)
        self.remainingTime = task.calcRemainingTimeInterval(atDate: date)
        self.taskName = task.name ?? L10n.noTaskName
        self.goalName = task.goal?.name ?? L10n.noGoal
        self.isProgressing = task.isProgressing(atDate: date)
        self.taskUri = task.uri
    }
    #endif

    init(fromDictionary dic:[String: Any]) {
        self.taskName = dic["taskName"] as! String
        self.percentage = dic["percentage"] as! Double
        self.remainingTime = dic["remainingTime"] as! TimeInterval
        self.goalName = dic["goalName"] as! String
        self.taskUri = dic["taskUri"] as! String
        self.isProgressing = dic["isProgressing"] as! Bool
    }
    
    var asDictionary:[String: Any] {
        return [
            "taskName": self.taskName,
            "percentage": self.percentage,
            "remainingTime": self.remainingTime,
            "goalName": self.goalName,
            "taskUri": self.taskUri,
            "isProgressing": self.isProgressing
        ]
    }
}
