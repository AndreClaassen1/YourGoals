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

/// a factory class for creating an new goal
class GoalFactory:StorageManagerWorker {
     
    /// create a goal form a goalInfo structure
    ///
    /// - Parameter goalInfo: a goal info structure
    /// - Throws: goal factory exception
    func create(fromGoalInfo goalInfo: GoalInfo) throws -> Goal {
        return try create(name: goalInfo.name, prio: 999, reason: goalInfo.reason, startDate: goalInfo.startDate, targetDate: goalInfo.targetDate, image: goalInfo.image)
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
    ///
    /// - Returns: the new created goal
    /// - Throws: a goal factory exception
    func create(name: String, prio:Int, reason: String, startDate:Date, targetDate:Date, image:UIImage?) throws -> Goal {
        let goal = self.manager.goalsStore.createPersistentObject()
        goal.name = name
        goal.prio = 999
        goal.reason = reason
        goal.startDate = startDate
        goal.targetDate = targetDate    
        
        let imageUpdater = ImageUpdater(manager: self.manager)
        try imageUpdater.updateImage(forGoal: goal, image: image)
        return goal
    }
    
    
  
    
}