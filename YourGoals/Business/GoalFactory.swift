//
//  GoalFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/// a factory class for creating new goals
class GoalFactory:StorageManagerWorker {
     
    /// create a goal form a goalInfo structure
    ///
    /// - Parameter goalInfo: a goal info structure
    /// - Throws: goal factory exception
    func create(fromGoalInfo goalInfo: GoalInfo) throws -> Goal {
        return try create(name: goalInfo.name!, prio: goalInfo.prio, reason: goalInfo.reason, startDate: goalInfo.startDate ?? Date.minimalDate, targetDate: goalInfo.targetDate ?? Date.maximalDate, image: goalInfo.image, backburned: goalInfo.backburned)
    }

    /// create a new goal with discrete values
    ///
    /// - Parameters:
    ///   - name: a name for the goal
    ///   - prio: a priority for the goal
    ///   - reason: the reason why the goal has to be achieed
    ///   - startDate: start date for the goal
    ///   - targetDate: the projected target date of the goal
    ///   - image: an optional image which should be convertable to a JPEG
    ///   - type: type of the goal: .strategy, .userGoal or .todayGoal
    ///   - backburned: true, if the goal is backburned
    ///
    /// - Returns: the new created goal
    /// - Throws: a goal factory exception
    func create(name: String, prio:Int16, reason: String, startDate:Date, targetDate:Date, image:UIImage?, type:GoalType = .userGoal, backburned: Bool) throws -> Goal {
        let goal = self.manager.goalsStore.createPersistentObject()
        goal.name = name
        goal.prio = prio
        goal.reason = reason
        goal.startDate = startDate
        goal.targetDate = targetDate
        goal.type = type.rawValue
        goal.backburned = backburned
        
        let imageUpdater = ImageUpdater(manager: self.manager)
        try imageUpdater.updateImage(forGoal: goal, image: image)
        try self.manager.saveContext()
        return goal
    }
}
