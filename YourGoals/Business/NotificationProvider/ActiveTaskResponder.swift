//
//  NotificationResponder.swift
//  YourGoals
//
//  Created by André Claaßen on 10.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// an action for a active progressing task
///
/// - done: the user wants to stop the task
/// - needMoreTime: the user needs more time
enum ActiveTaskResponderAction {
    case done
    case needMoreTime
    case addTask
    case startTask
}

/// the user clicks on a button on a notification or on the watch to perform a certain action for the active progressing task
class ActiveTaskResponder {
    let progressManager:TaskProgressManager!
    let todayGoalComposer:TodayGoalComposer!
    let stateManager:TaskStateManager!
    let manager: GoalsStorageManager!
    
    /// init the handler of the task notificaiton
    ///
    /// - Parameters:
    ///   - manager: a Goals Storage Manager
    init(manager: GoalsStorageManager) {
        self.manager = manager
        self.progressManager = TaskProgressManager(manager: manager)
        self.stateManager = TaskStateManager(manager: manager)
        self.todayGoalComposer = TodayGoalComposer(manager: manager)
    }
    
    /// perform an action for the active progressing task
    ///
    /// - Parameter
    ///   - taskUri: the uri of the task
    ///   - action: a active task repsonder action
    ///   - date: the date for the action
    /// - Throws: a core data exception
    func performAction(action: ActiveTaskResponderAction, taskUri uri: String, forDate date: Date) {
        do {
            let task = try self.manager.tasksStore.retrieveExistingObject(fromUriStr: uri)
            switch action {
            case .done:
                try stateManager.setTaskState(task: task, state: .done, atDate: date)
            case .needMoreTime:
                try progressManager.changeTaskSize(forTask: task, delta: 15.0, forDate: date)
            case .startTask:
                try stateManager.setTaskState(task: task, state: .active, atDate: date)
            default:
                assertionFailure("performAction taskUri: action not allowed")
            }
        }
        catch let error {
            NSLog("performAction taskUri aborted for action \(action) with error: \(error)")
        }
    }
    
    func performAction(action: ActiveTaskResponderAction, taskDescription description: String, forDate date: Date) {
        do {
            switch action {
            case .addTask:
                try self.todayGoalComposer.addTask(withDescription: description, forDate: date)
            default:
                assertionFailure("performAction taskUri: action not allowed")
            }
        }
        catch let error {
            NSLog("performAction taskUri aborted for action \(action) with error: \(error)")
        }
    }
}
