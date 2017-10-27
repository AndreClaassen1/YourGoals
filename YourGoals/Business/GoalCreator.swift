//
//  GoalCreator.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum GoalCreatorError : Error{
    case activeStrategyMissingError
    case imageNotJPegError
}


class GoalCreator {
    
    let manager:GoalsStorageManager
    
    init (manager:GoalsStorageManager) {
        self.manager = manager
    }
    
    func createNewGoal(goalInfo: GoalInfo) throws {
        guard let strategy = try StrategyRetriever(manager: manager).activeStrategy() else {
            throw GoalCreatorError.activeStrategyMissingError
        }
        
        let goal = self.manager.goalsStore.createPersistentObject()
        goal.name = goalInfo.name
        goal.prio = 999
        goal.reason = goalInfo.reason
        guard let data = UIImageJPEGRepresentation(goalInfo.image, 0.6) else {
            throw GoalCreatorError.imageNotJPegError
        }
        
        let imageData = self.manager.imageDataStore.createPersistentObject()
        imageData.data = data
        goal.imageData = imageData
        
        strategy.addToSubGoals(goal)
        try manager.dataManager.saveContext()
    }
}
