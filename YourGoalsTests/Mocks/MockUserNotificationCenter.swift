//
//  MockUserNotificationCenter.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 30.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UserNotifications
@testable import YourGoals

/// Mock Notifications
class MockNotification  {
    
    let date:Date
    let request:UNNotificationRequest
    
    init(date:Date, request:UNNotificationRequest) {
        self.date = date
        self.request = request
    }
}

/// Simulation of the UNUserNotificationCenter for Unit Testing purpposes
class MockUserNotificationCenter : UNNotificationCenterProtocol {
    
    var pendingRequests = [UNNotificationRequest]()
    var deliverdRequests = [MockNotification]()
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Swift.Void)? ) {
        let calendarTrigger = request.trigger as! UNCalendarNotificationTrigger
        if let _ = calendarTrigger.nextTriggerDate() {
            self.pendingRequests.append(request)
        } else {
            let calendar = Calendar.current
            let date = calendar.date(from: calendarTrigger.dateComponents)!
            self.deliverdRequests.append(MockNotification(date: date, request: request))
        }
        completionHandler?(nil)
    }
    
    // Notification requests that are waiting for their trigger to fire
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Swift.Void) {
        completionHandler(self.pendingRequests)
    }
    
    // Notification categories can be used to choose which actions will be displayed on which notifications.
    func setNotificationCategories(_ categories: Set<UNNotificationCategory>) {
        
    }
    
    func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
    }
    
    func removeAllPendingNotificationRequests() {
        self.pendingRequests = []
    }
    
    func removeAllDeliveredNotifications() {
        self.deliverdRequests = []
    }
    
    // Notifications that have been delivered and remain in Notification Center. Notifiations triggered by location cannot be retrieved, but can be removed.
    func getDeliveredNotifications(completionHandler: @escaping ([UNNotification]) -> Swift.Void) {
        //   completionHandler(self.deliverdRequests)
    }
}
