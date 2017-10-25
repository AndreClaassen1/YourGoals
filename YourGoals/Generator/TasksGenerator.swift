//
//  TasksGenerator.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class TasksGenerator : Generator, GeneratorProtocol{
    
    func generate() throws {
        let retriever = StrategyRetriever(manager: self.manager)
        guard let strategy = try retriever.activeStrategy() else {
            fatalError("no strategy found")
        }
        
        for goal in strategy.allGoals() {
            for i in 0 ..< 3 {
                let task = self.manager.tasksStore.createPersistentObject()
                
                task.name = "Task \(i + 1) is to be done"
                task.setTaskState(state: .planned)
                goal.addToTasks(task)
            }
        }
    }
}

