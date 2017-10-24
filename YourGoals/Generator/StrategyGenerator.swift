//
//  FitnessHistoryGenerator.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 03.06.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

class StrategyGenerator : Generator, GeneratorProtocol {
    
    let goals = [
        (prio: 1,
         name: "YourGoals entwickeln",
         image: "YourGoals",
         reason: "Ich brauche eine App, die meinem Ziel der Zielentwicklung optimal gerecht wird. Und das ist visuell und gewohnheitsorientiert",
         targetDate: Date.dateWithYear(2018, month: 05, day: 19)),
        (prio: 2,
         name: "YourDay fertig stellen",
         image: "YourDay",
         reason: "Ich möchte mein Journal in der Form in den Store stellen, dass es ein gutes Feedback gibt.",
         targetDate: Date.dateWithYear(2018, month: 02, day: 39)),

    ]
    // MARK: GeneratorProtocol
    
    func generate() throws {
        
        let strategy = try createParentGoal()
        
        for tuple in goals {
            let goal = self.manager.goalsStore.createPersistentObject()
            goal.name = tuple.name
            goal.reason = tuple.reason
            goal.prio = Int16(tuple.prio)
            goal.targetDate = tuple.targetDate
            goal.parentGoal = strategy
            
            let imageData = self.manager.imageDataStore.createPersistentObject()
            guard let image = UIImage(named: tuple.image) else {
                NSLog("could not create an image from tuple data: (\tuple)")
                continue
            }
            
            imageData.setImage(image: image)
            goal.imageData = imageData
        }
    }
    
    func createParentGoal() throws ->  Goal  {
        let strategy = manager.goalsStore.createPersistentObject()
        strategy.name = "Meine Strategie"
        return strategy
    }
}
