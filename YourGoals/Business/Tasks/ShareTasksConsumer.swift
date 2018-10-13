//
//  ShareTasksConsumer.swift
//  YourGoals
//
//  Created by André Claaßen on 11.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import YourGoalsKit

/// this class consumes new tasks genereated from
/// the Your Goals Share extension
/// it fetches the tasks from the buffer store
/// in the app group and creates new tasks in the
/// document data store
class ShareTasksConsumer:StorageManagerWorker {
    
    /// the helper class to provide task infos from the app group storage
    let provider:ShareExtensionTasksProvider
    
    /// all new tasks will be created in the today screen.
    let todayGoalComposer:TodayGoalComposer
    
    /// initialize the share tasks consumer object
    ///
    /// - Parameters:
    ///   - goalsStorageManager: store manager in the document group
    ///   - shareStorageManager: store manager in the application group
    init(goalsStorageManager: GoalsStorageManager, shareStorageManager:ShareStorageManager) {
        self.provider = ShareExtensionTasksProvider(manager: shareStorageManager)
        self.todayGoalComposer = TodayGoalComposer(manager: goalsStorageManager)
        super.init(manager: goalsStorageManager)
    }
    
    /// consume all tasks from the share extension and create
    /// tasks for the today goal.
    ///
    /// - Parameter date: commitment date for the new tasks
    func consumeTasksFromShare(forDate date:Date) {
        do {
            try self.provider.consumeNewTasksFromExtension { shareNewTask in
                guard let taskName = shareNewTask.taskname else {
                    return
                }
                
                let actionableInfo = ActionableInfo(
                    type: .task,
                    name: taskName,
                    commitDate: date,
                    url: shareNewTask.url,
                    imageData: shareNewTask.image)
                
                try self.todayGoalComposer.create(actionableInfo: actionableInfo)
            }
        }
        catch let error {
            NSLog("error in consumeTasksFromShare \(error)")
        }
    }
}
