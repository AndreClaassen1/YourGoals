//
//  UNNotificationCenterProtocol.swift
//  YourGoals
//
//  Created by André Claaßen on 30.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UserNotifications

//
//  UNNotificationCenterProtocol.swift
//  YourDay
//
//  Created by André Claaßen on 30.08.17.
//  Copyright © 2017 Andre Claaßen. All rights reserved.
//

import Foundation
import UserNotifications

/// Abstraction to UNNotificationCenter for UnitTesting Purposes
protocol UNNotificationCenterProtocol {
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Swift.Void)? )
    
    // Notification requests that are waiting for their trigger to fire
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Swift.Void)
    
    // Notification categories can be used to choose which actions will be displayed on which notifications.
    func setNotificationCategories(_ categories: Set<UNNotificationCategory>)
    
    func removeDeliveredNotifications(withIdentifiers identifiers: [String])
    
    func removeAllPendingNotificationRequests()
    
    func removeAllDeliveredNotifications()
    
    // Notifications that have been delivered and remain in Notification Center. Notifiations triggered by location cannot be retrieved, but can be removed.
    func getDeliveredNotifications(completionHandler: @escaping ([UNNotification]) -> Swift.Void)
}

extension UNUserNotificationCenter : UNNotificationCenterProtocol {
    
}
