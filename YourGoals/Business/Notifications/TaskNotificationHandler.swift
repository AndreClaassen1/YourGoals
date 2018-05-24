//
//  TaskNotificationHandler.swift
//  YourGoals
//
//  Created by André Claaßen on 02.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

/// this class handles the actions of a task notification
class TaskNotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    let taskResponder:ActiveTaskResponder!
    
    /// init the handler of the task notificaiton
    ///
    /// - Parameters:
    ///   - manager: a Goals Storage Manager
    init(manager: GoalsStorageManager) {
        self.taskResponder = ActiveTaskResponder(manager: manager)
        super.init()
    }
    
    /// connect this class with the notification center and register the badge
    func registerNotifications() {
        let current = UNUserNotificationCenter.current()
        current.delegate = self
        current.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if let error = error {
                NSLog("UNUserNotificationCenter.current().requestAuthorization: \(error.localizedDescription)")
            }
        }
    }
    
    /// handle the real action response as a testable function
    ///
    /// - Parameters:
    ///   - identifier: the action identifier string (the button of the notification)
    ///   - uri: a task uri
    ///   - date: the reference date and time for changing the progress
    /// - Throws: a core data or storage error
    func handleActionResponse(forIdentifier identifier: String, andTaskUri uri:String, forDate date:Date) throws {
        switch identifier {
        case TaskNotificationActionIdentifier.done:
            self.taskResponder.performAction(action: .done, taskUri: uri, forDate: date)
            break
        case TaskNotificationActionIdentifier.needMoreTime:
            self.taskResponder.performAction(action: .needMoreTime, taskUri: uri, forDate: date)
            break
        default:
            assertionFailure("unknown response.actionIdentifier: \(identifier)")
        }
    }
    
    /// user has selected an action for the notification
    ///
    /// - Parameters:
    ///   - center: user notification center
    ///   - response: response selected from the user
    ///   - completionHandler: hanlder for completion
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let currentDateTime = Date()

        do {
            guard let taskUri = response.notification.request.content.userInfo["taskUri"] as? String else {
                NSLog("TaskNotificationHandler: couldn't extract task uri from request \(response.notification.request)")
                return
            }
            try handleActionResponse(forIdentifier: response.actionIdentifier, andTaskUri: taskUri, forDate: currentDateTime)
        }
        catch let error {
            NSLog("TaskNotificationHandler: error occured: \(error)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         completionHandler([.sound, .alert, .badge])
    }
}
