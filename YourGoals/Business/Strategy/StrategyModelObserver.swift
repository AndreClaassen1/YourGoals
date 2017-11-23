//
//  StrategyModelObserver.swift
//  YourGoals
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation


/// a class for notifying a state change in the date model
class StrategyModelObserver:StorageManagerWorker, StrategyModelObserverDelegate {
    
    static lazy let global = StrategyModelObserver(manager: GoalsStorageManager.defaultStorageManager)
    
    let taskStateManager:TaskStateManager
    let taskProgressManager:TaskProgressManager
    var observers:[StrategyModelObserverDelegate] = []
    
    override init(manager: GoalsStorageManager) {
        self.taskStateManager = TaskStateManager(manager: manager)
        self.taskProgressManager = TaskProgressManager(manager: manager)
        super.init(manager: manager)
    }
    
    func registerObserver(_ observer:StrategyModelObserverDelegate) {
        self.observers.append(observer)
    }
    
    // MARK: - StrategyModelUpdateDelegate
    
    func taskStateChanged(task: Task) {
        observers.forEach {
            $0.taskStateChanged(task: task)
        }
    }
}
