//
//  UNCalendarNotificationTrigger+Date.swift
//  YourGoals
//
//  Created by André Claaßen on 29.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UserNotifications

extension UNCalendarNotificationTrigger {
    
    /// create a notification trigger for the scheduled date
    ///
    /// - Parameter time: date & time
    /// - Returns: the trigger
    convenience init(fireDate time: Date) {
        let fireDateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: time)
        self.init(dateMatching: fireDateComponents, repeats: false)
    }
}

