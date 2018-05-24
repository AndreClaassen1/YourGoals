//
//  TaskNotificationObserver.swift
//  YourGoals
//
//  Created by André Claaßen on 03.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation



class TaskNotificationObserver: TaskNotificationProviderProtocol {
    
    static let defaultObserver = TaskNotificationObserver()
    
    var notificationProvider:[TaskNotificationProviderProtocol] = []
    
    func register(provider:TaskNotificationProviderProtocol) {
        self.notificationProvider.append(provider)
    }
    
    // MARK: TaskNotificationProvicderProtocol
    
    func progressStarted(forTask task: Task, referenceTime: Date) {
        notificationProvider.forEach({ $0.progressStarted(forTask: task, referenceTime: referenceTime) })
    }
    
    func progressChanged(forTask task: Task, referenceTime: Date) {
        notificationProvider.forEach({ $0.progressChanged(forTask: task, referenceTime: referenceTime) })
    }
    
    func progressStopped() {
        notificationProvider.forEach({ $0.progressStopped() })
    }
    
    func tasksChanged() {
        notificationProvider.forEach({ $0.tasksChanged() })
    }
    
}
