//
//  FitnessHistoryGenerator.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 03.06.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation

class StrategyGenerator : Generator, GeneratorProtocol {
    
    let goals = [
        (prio: 1,
         name: "YourGoals entwickeln",
         reason: "Ich brauche eine App, die meinem Ziel der Zielentwicklung optimal gerecht wird. Und das ist visuell und gewohnheitsorientiert",
         targetDate: Date.dateWithYear(2018, month: 05, day: 19))
    ]
    // MARK: GeneratorProtocol
    
    func generate() throws {
        
        let strategy = try createParentGoal()
        
        for tuple in goals {
            let goal = try self.manager.goalsStore.createPersistentObject()
            goal.name = tuple.name
            goal.reason = tuple.reason
            goal.prio = Int16(tuple.prio)
            goal.targetDate = tuple.targetDate
        }
    }
    
    func createParentGoal() throws ->  Goal  {
        let strategy = manager.goalsStore.createPersistentObject()
        strategy.name = "Meine Strategie"
        return strategy
    }
}
