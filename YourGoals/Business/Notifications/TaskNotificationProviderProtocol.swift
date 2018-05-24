//
//  TaskNotificationProviderProtocol.swift
//  YourGoals
//
//  Created by André Claaßen on 03.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation


/// a protocol for triggering the create of local user notifications
protocol TaskNotificationProviderProtocol {
    func progressStarted(forTask task:Task, referenceTime:Date)
    func progressChanged(forTask task:Task, referenceTime:Date)
    func progressStopped()
    func tasksChanged()
}
