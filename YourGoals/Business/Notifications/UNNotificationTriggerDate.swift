//
//  UNNotificationTriggerDate.swift
//  YourGoals
//
//  Created by André Claaßen on 04.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
import UserNotifications

protocol UNNotificationTriggerDate {
    func nextTriggerDate() -> Date?
    func plannedTriggerDate() -> Date
}

extension UNCalendarNotificationTrigger: UNNotificationTriggerDate {
    func plannedTriggerDate() -> Date {
        let calendar = Calendar.current
        let date = calendar.date(from: self.dateComponents)!
        return date
    }
}

extension UNTimeIntervalNotificationTrigger:UNNotificationTriggerDate {
    func plannedTriggerDate() -> Date {
        return TimeCapsule().currentDateTime
    }
}
