//
//  TodayWorkloadInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 08.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

struct WorkloadInfo {
    let totalRemainingTime: TimeInterval
    let totalTasksLeft: Int
    let endTime: Date
}

class TodayWorkloadCalculator: StorageManagerWorker {

    typealias infoTuple = (remainingTime: TimeInterval, tasksLeft: Int)
    
    func calcWorkload(forDate date: Date, backburned: Bool) throws -> WorkloadInfo {
        let todayDataSource  = TodayAllActionablesDataSource(manager: self.manager, backburned: backburned)
        let actionables = try todayDataSource.fetchActionables(forDate: date, andSection: nil)
        let sumInfo = actionables.reduce((remainingTime: TimeInterval(0.0), tasksLeft: 0)) { i, actionable in
            let remainingTime = actionable.calcRemainingTimeInterval(atDate: date)
            return (i.remainingTime +  remainingTime, i.tasksLeft + 1)
        }
        let endTime = date.addingTimeInterval(sumInfo.remainingTime)
        
        return WorkloadInfo(totalRemainingTime: sumInfo.remainingTime, totalTasksLeft: sumInfo.tasksLeft, endTime: endTime )
    }
}
