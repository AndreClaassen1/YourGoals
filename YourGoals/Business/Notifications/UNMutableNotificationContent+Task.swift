//
//  UNMutableNotificationContent+Task.swift
//  YourGoals
//
//  Created by André Claaßen on 31.05.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
import UserNotifications

extension UNMutableNotificationContent {
    convenience init(task: Task, text: String) {
        self.init()
        self.categoryIdentifier = TaskNotificationCategory.taskNotificationCategory
        self.body = task.name ?? "No task name"
        self.title = text
        self.sound = UNNotificationSound.default
        self.userInfo = [
            "taskUri": task.objectID.uriRepresentation().absoluteString
        ]
    }
}
