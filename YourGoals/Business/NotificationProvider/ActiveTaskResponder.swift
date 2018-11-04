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
/// - addTask: the user wants to add a new task
/// - startTask: the user wants to start a task
/// - stopTask: the user wants to stop the work on a task
enum ActiveTaskResponderAction {
    case done
    case needMoreTime
    case addTask
    case startTask
    case stopTask
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
                try progressManager.startProgress(forTask: task, atDate: date)
            case .stopTask:
                try progressManager.stopProgress(forTask: task, atDate: date)
                
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
                try self.todayGoalComposer.create(
                    actionableInfo: ActionableInfo(type: .task, name: description, commitDate: date))
            default:
                assertionFailure("performAction taskUri: action not allowed")
            }
        }
        catch let error {
            NSLog("performAction taskUri aborted for action \(action) with error: \(error)")
        }
    }
}
