//
//  TaskWorkingTimeTextCreator.swift
//  YourGoals
//
//  Created by André Claaßen on 13.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation

/// helper for formatting the text of an task actionable table cell
struct TaskWorkingTimeTextCreator {
    
    /// calculate several textes for the working time and progress
    /// of the actionables
    ///
    /// - Parameters:
    ///   - actionable: the task or habit
    ///   - date: calculate values for this date
    ///   - estimatedStartingTsime: estimated starting time of the task
    ///
    /// - Returns: a tuple consisting of several formatted strings of
    ///            starting time, working time range, remaining time and the total working time
    func timeLabelsForTasks(actionable: Actionable, forDate date: Date, estimatedStartingTime timeInfo: ActionableTimeInfo?) -> (startingTimeText: String?, workingTime:String?, remainingTime: String?, remainingTimeInMinutes: String?, totalWorkingTime: String?) {
        guard actionable.type == .task else {
            return (nil, nil, nil, nil, nil)
        }
        
        let totalWorkingTime = actionable.calcProgressDuration(atDate: date)?.formattedAsString()
        
        guard actionable.checkedState(forDate: date) == .active else {
            return (nil, nil, nil, nil, totalWorkingTime)
        }
        
        if let timeInfo = timeInfo {
            let fixedIndicator = timeInfo.fixedStartingTime ? "*" : ""
            let startingTimeText = "\(fixedIndicator)\(timeInfo.startingTime.formattedTime())"
            let endTimeText = "\(timeInfo.endingTime.formattedTime())"
            let remainingTimeInMinutesText = "(\(timeInfo.estimatedLength.formattedInMinutesAsString(supressNullValue: false)))"
            let workingTimeText = startingTimeText + " - " + endTimeText + " " + remainingTimeInMinutesText
            return (startingTimeText, workingTimeText, timeInfo.estimatedLength.formattedAsString(), remainingTimeInMinutesText, totalWorkingTime)
        } else {
            let remainingTime = actionable.calcRemainingTimeInterval(atDate: date)
            let remainingTimeInMinutesText = "(\(remainingTime.formattedInMinutesAsString()))"
            return (nil, nil, remainingTime.formattedAsString(), remainingTimeInMinutesText, totalWorkingTime)
        }
    }
    
    func timeLabelsForActiveLife(timeInfo: ActionableTimeInfo, forDate date: Date) -> (startingTimeText: String, remainingTime: String, remainingTimeInMinutes: String) {
        let fixedIndicator = timeInfo.fixedStartingTime ? "*" : ""
        let startingTimeText = "\(fixedIndicator)\(timeInfo.startingTime.formattedTime())"
        let remainingTimeInMinutesText = "(\(timeInfo.estimatedLength.formattedInMinutesAsString(supressNullValue: false)))"
        let remainingTime = timeInfo.estimatedLength.formattedAsString()
        return (startingTimeText, remainingTime, remainingTimeInMinutesText)
    }
}
