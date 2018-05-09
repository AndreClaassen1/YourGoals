//
//  GoalUpdater.swift
//  YourGoals
//
//  Created by André Claaßen on 28.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

/// helper class for updating a goal in the data store
class GoalUpdater:StorageManagerWorker {

    /// update the goal with informations from the goal info object
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - goalInfo: goal info data from the form editor
    /// - Throws: core data exception
    func update(goal:Goal, withGoalInfo goalInfo: GoalInfo) throws {
        if let name = goalInfo.name {
            goal.name = name
        }
        goal.reason = goalInfo.reason
        if goal.goalType() != .todayGoal {
            if let startDate = goalInfo.startDate {
                goal.startDate = startDate
            }
            
            if let targetDate = goalInfo.targetDate {
                goal.targetDate = targetDate
            }
        }
        goal.backburned = goalInfo.backburned
        let imageUpdater = ImageUpdater(manager: self.manager)
        try imageUpdater.updateImage(forGoal: goal, image: goalInfo.image)
        try self.manager.dataManager.saveContext()
    }    
}
