//
//  TaskNotificationHandlerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import XCTest
import UserNotifications
@testable import YourGoals

/// Tests for the TaskNotificationScheduler
class TaskNotificationHandlerTests: StorageTestCase {
    var progressManager:TaskProgressManager!
    var notificationHandler:TaskNotificationHandler!
    
    override func setUp() {
        super.setUp()
        self.progressManager = TaskProgressManager(manager: self.manager)
        self.notificationHandler = TaskNotificationHandler(progressManager: self.progressManager)
    }
    
    /// given a task is in progress
    /// when the notificatoin appears, the user clicks "I need more time"
    /// the remaining time of the task is 15 Minutes longer
    func testActionNeedMoreTime(){
        // given a task is in progress
        let task = TaskFactory(manager: self.manager).create(name: "Task with started progress", state: .active, prio: 1, sizeInMinutes: 30.0)
        
        // save to the store to get a valid objectId
        try!self.manager.saveContext()
        let taskUri = task.objectID.uriRepresentation().absoluteString
        
        // start the task at exactly 12:00:00
        let progressStartDate = Date.dateTimeWithYear(2018, month: 04, day: 01, hour: 12, minute: 00, second: 00)
        try! self.progressManager.startProgress(forTask: task, atDate: progressStartDate)
        
        // the  notification appears after 15 Minutes
        let notificationDate = progressStartDate.addMinutesToDate(15)
        let remainingTime = task.calcRemainingTimeInterval(atDate: notificationDate) / 60.0
        XCTAssertEqual(remainingTime, 15.0, "After 15 Minutes the remaining time should be 15 Minutes")
        
        // the user clicks "I need more time"
        try! self.notificationHandler.handleActionResponse(forIdentifier: TaskNotificationActionIdentifier.needMoreTime, andTaskUri: taskUri, forDate: notificationDate)
        let remainingTimeAfterClicking = task.calcRemainingTimeInterval(atDate: notificationDate) / 60.0
        
        // the remaining time should be 15 minutes longer
        XCTAssertEqual(remainingTimeAfterClicking, 30.0, "After clicking I need more time the remaining time should be 30 minutes more")
    }
}


