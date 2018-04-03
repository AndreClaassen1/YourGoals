//
//  TaskNotificationScheduler.swift
//  YourGoals
//
//  Created by André Claaßen on 26.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UserNotifications

/// this class creates notification on started or stopped tasks
class TaskNotificationScheduler:TaskNotificationProviderProtocol {
    /// the user notification center
    let center:UNNotificationCenterProtocol

    /// initialize the task notification maanger with the user notification cente
    ///
    /// - Parameter notificationCenter: default is UNUserNotificationCenter.current() or a UnitTest Mockup
    init(notificationCenter:UNNotificationCenterProtocol, observer:TaskNotificationObserver) {
        self.center = notificationCenter
        setupNotificationActions()
        observer.register(provider: self)
    }
    
    /// schedule a local notification for the task to informa about remaining time
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - text: a notification text
    ///   - referenceTime: the reference date to calculate the notification time
    ///   - remainingTime: the remaining time for the task
    func scheduleLocalNotification(forTask task:Task, withText text:String, referenceTime: Date, remainingTime: TimeInterval) {
        guard let taskName = task.name else {
            NSLog("Task with no name")
            return
        }
        
        guard remainingTime >= 0.0 else {
            NSLog("there is no time left for task \(taskName) to schedule a notification!")
            return
        }

        let content = UNMutableNotificationContent()
        content.categoryIdentifier = TaskNotificationCategory.taskNotificationCategory
        content.body = taskName
        content.title = text
        content.sound = UNNotificationSound.default()
        content.userInfo = [
            "taskUri": task.objectID.uriRepresentation().absoluteString
        ]
        
        let scheduleTime = referenceTime.addingTimeInterval(remainingTime);
        let trigger = UNCalendarNotificationTrigger(fireDate: scheduleTime)
        let request = UNNotificationRequest(identifier: text , content: content, trigger: trigger)
        
        self.center.add(request, withCompletionHandler: nil)
    }
    
    /// eliminate all notifications
    func resetNotifications() {
        self.center.removeAllPendingNotificationRequests()
        self.center.removeAllDeliveredNotifications()
    }
    
    /// setup the custom actions for all motivation card notifications
    /// edit action for taking immediate input
    /// delay action for delaying a motivation card
    func setupNotificationActions() {
        let needMoreTimeAction = UNNotificationAction(
            identifier: TaskNotificationActionIdentifier.needMoreTime ,
            title:  "I need more time",
            options: [])
        
        let doneAction = UNNotificationAction(
            identifier: TaskNotificationActionIdentifier.done ,
            title:  "I'm done'",
            options: [])

        let category = UNNotificationCategory(identifier: TaskNotificationCategory.taskNotificationCategory,
                                              actions: [needMoreTimeAction, doneAction],
                                              intentIdentifiers: [], options: [])

        center.setNotificationCategories([category])
    }
    
    /// show depending notifications on log
    func debugPendingNotifications() {
        self.center.getPendingNotificationRequests { (requests) in
            for r in requests {
                NSLog("user local notification is pending: \(r.content.title)")
            }
            NSLog("+++ ready")
        }
    }
 
    func scheduleRemainingTimeNotifications(forTask task: Task, referenceTime:Date) {
        let remainingTime = task.calcRemainingTimeInterval(atDate: referenceTime)
        scheduleLocalNotification(forTask: task, withText: "You have only 10 Minutes left for your task!", referenceTime: referenceTime, remainingTime: remainingTime - (10.0 * 60.0))
        scheduleLocalNotification(forTask: task, withText: "You have only 5 Minutes left for your task!", referenceTime: referenceTime, remainingTime: remainingTime - (5.0 * 60.0))
        scheduleLocalNotification(forTask: task, withText: "Your time is up!", referenceTime: referenceTime, remainingTime: remainingTime)
    }
    
    
    // mark: - TaskNotificationProviderProtocol
    
    /// create user local notifications for a freshly started task. 
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - referenceTime: the reference date for calculation
    ///   - remainingTime: remaining time for the task. this is important for calculate the calendar trigger time
    func progressStarted(forTask task: Task, referenceTime: Date) {
        scheduleLocalNotification(forTask: task, withText: "Your Task is startet. Do your work!", referenceTime: referenceTime.addingTimeInterval(10.0), remainingTime: 0.0)
        scheduleRemainingTimeNotifications(forTask: task, referenceTime: referenceTime)
    }
    
    /// inform the user about start and remaining time for a task
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - referenceTime: the reference time for the notification
    func progressChanged(forTask task: Task, referenceTime: Date) {
        resetNotifications()
        scheduleRemainingTimeNotifications(forTask: task, referenceTime: referenceTime)
    }
    
    /// all progress is stoppped. kill all pending notifications
    func progressStopped() {
        // kill all notifications
        resetNotifications()
    }
}
