//
//  TasksGenerator.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// generate test tasks
class TasksGenerator : Generator, GeneratorProtocol{
    
    func generate() throws {
        let retriever = StrategyManager(manager: self.manager)
        guard let strategy = try retriever.retrieveActiveStrategy() else {
            fatalError("no strategy found")
        }
        
        for goal in strategy.allGoals() {
            let taskFactory = TaskFactory(manager: self.manager)
            
            for i in 0 ..< 3 {
                let task = taskFactory.create(name: "Task \(i + 1) is to be done", state: .active, prio: Int16(i))
                goal.addToTasks(task)
            }
        }
    }
}

