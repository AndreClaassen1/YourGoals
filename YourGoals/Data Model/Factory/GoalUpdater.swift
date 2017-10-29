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

    func update(goal:Goal, withGoalInfo goalInfo: GoalInfo) throws {
        goal.name = goalInfo.name
        goal.reason = goalInfo.reason
        let imageUpdater = ImageUpdater(manager: self.manager)
        try imageUpdater.updateImage(forGoal: goal, image: goalInfo.image)
        try self.manager.dataManager.saveContext()
    }    
}
