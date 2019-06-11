//
//  TaskNotificationScheduler.swift
//  YourGoals
//
//  Created by André Claaßen on 26.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UserNotifications

struct TaskNotificationOverdueText {
    /// creates a localized text for task overrunning with hours and minutes
    ///
    /// - Parameters:
    ///   - hours: overdue in hours
    ///   - minutes: overdue in minutes
    /// - Returns: a localized text strijng
    static func textForTaskOverrunning(hours: Int, minutes: Int) -> String {
        let text = hours == 0 ? L10n.theTimeForYourTaskIsOverrunning(minutes) : L10n.theTimeForYourTaskIsOverrunningInHours(hours)
        return text
    }
}

/// this class creates notification on started or stopped tasks
class TaskNotificationScheduler:TaskNotificationProviderProtocol {
    /// the user notification center
    let center:UNNotificationCenterProtocol
    var overdueTimer:Timer? = nil
    let overdueIntervalInMinutes = 15.0

    /// initialize the task notification maanger with the user notification cente
    ///
    /// - Parameter notificationCenter: default is UNUserNotificationCenter.current() or a UnitTest Mockup
    init(notificationCenter:UNNotificationCenterProtocol, observer:TaskNotificationObserver) {
        self.center = notificationCenter
        setupNotificationActions()
        observer.register(provider: self)
    }
    
    /// schedule a local notification for the task to inform the user about the remaining time
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - text: a notification text
    ///   - referenceTime: the reference date to calculate the notification time
    ///   - remainingTime: the remaining time for the task
    func scheduleLocalNotification(forTask task:Task, withText text:String, referenceTime: Date, remainingTime: TimeInterval) {
        
        let content = UNMutableNotificationContent(task: task, text: text)
        let scheduleTime = referenceTime.addingTimeInterval(remainingTime);
        let trigger = UNCalendarNotificationTrigger(fireDate: scheduleTime)
        let request = UNNotificationRequest(identifier: text , content: content, trigger: trigger)
        
        self.center.add(request, withCompletionHandler: nil)
    }
    
    /// schedule a local notification for a timer overrun
    ///
    /// - Parameters:
    ///   - forTask: the task
    ///   - referenceTime: the reference datetime for calculating the notification time
    ///   - remainingTime: the remaining time of the task
    ///   - overdueInMinutes: the needed overdue reminder in Minutes
    func scheduleTimerOverrunNotification(forTask task: Task, referenceTime: Date, remainingTime: TimeInterval, overdueInMinutes: Int) {
        let hours = overdueInMinutes / 60
        let minutes = overdueInMinutes % 60
        let text = TaskNotificationOverdueText.textForTaskOverrunning(hours: hours, minutes: minutes)
        scheduleLocalNotification(forTask: task, withText: text, referenceTime: referenceTime, remainingTime: remainingTime + Double(overdueInMinutes) * 60.0)
    }
    
    /// eliminate all notifications and stop overdue notifications
    func resetNotifications() {
        self.center.removeAllPendingNotificationRequests()
        self.center.removeAllDeliveredNotifications()
        if let timer = self.overdueTimer {
            timer.invalidate()
        }
        self.overdueTimer = nil
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

    /// create a series of local push notifications for the task.
    ///
    /// Push notifications for 50% of the task size, 10 and 5 minutes remaining time.
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - referenceTime: the reference time for calculations
    func scheduleRemainingTimeNotifications(forTask task: Task, referenceTime:Date) {
        let remainingTime = task.calcRemainingTimeInterval(atDate: referenceTime)
        if task.size >= 30.0 {
            scheduleLocalNotification(forTask: task, withText: L10n.youHaveReached50OfYourTimebox(50), referenceTime: referenceTime, remainingTime: remainingTime - Double(task.size / 2.0 * 60.0))
        }
        
        scheduleLocalNotification(forTask: task, withText: L10n.youHaveOnly10MinutesLeftForYourTask, referenceTime: referenceTime, remainingTime: remainingTime - (10.0 * 60.0))
        scheduleLocalNotification(forTask: task, withText: L10n.youHaveOnly5MinutesLeftForYourTask, referenceTime: referenceTime, remainingTime: remainingTime - (5.0 * 60.0))
        scheduleLocalNotification(forTask: task, withText: L10n.yourTimeIsUp, referenceTime: referenceTime, remainingTime: remainingTime)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 5)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 10)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 15)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 30)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 45)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 60)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 120)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 180)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 240)
        scheduleTimerOverrunNotification(forTask: task, referenceTime: referenceTime, remainingTime: remainingTime, overdueInMinutes: 360)
    }
    
    // mark: - TaskNotificationProviderProtocol
    
    /// create user local notifications for a freshly started task. 
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - referenceTime: the reference date for calculation
    ///   - remainingTime: remaining time for the task. this is important for calculate the calendar trigger time
    func progressStarted(forTask task: Task, referenceTime: Date) {
        scheduleLocalNotification(forTask: task, withText: L10n.YourTaskIsStartet.doYourWork, referenceTime: referenceTime.addingTimeInterval(10.0), remainingTime: 0.0)
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
    
    func tasksChanged() {
        
    }
}
