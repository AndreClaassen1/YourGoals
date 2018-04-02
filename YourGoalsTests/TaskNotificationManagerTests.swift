//
//  TaskNotificationTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 26.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
import UserNotifications
@testable import YourGoals

/// Tests for the TaskNotificationManager
class TaskNotificationManagerTests: StorageTestCase {
    
    /// Given an task action
    /// when I start the task
    /// then I've got two local user notifications 5 minutes before the task end and when the task stops
    func testUserNotificationAtTaskStart(){
        // prepare the singletions
        let expectation = self.expectation(description: "pending notification")
        let mockUserNotificationCenter = MockUserNotificationCenter()
        let taskNotificationManager = TaskNotificationManager(notificationCenter: mockUserNotificationCenter)
        let progressManager = TaskProgressManager(manager: self.manager, taskNotificationProtocol: taskNotificationManager)
        
        // Given an task action with a duration(size) of 30 Minutes
        let task = TaskFactory(manager: self.manager).create(name: "Task with started progress", state: .active, prio: 1, sizeInMinutes: 30.0)
        
        // date must be far in the future because next trigger date should be working
        let progressStartDate = Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 00, second: 00)
        
        // when I start the ask
        try! progressManager.startProgress(forTask: task, atDate: progressStartDate)
        
        // test
        mockUserNotificationCenter.getPendingNotificationRequests { (requests) in
            expectation.fulfill()
            let nextTriggerDates = requests.map { ($0.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()!  }
            XCTAssertEqual ( [
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 20, second: 00), // first notification 10 minutes before task end
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 25, second: 00), // seconod notification 5 minutes before the tasks end
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 30, second: 00)  // last notification at end of the task
                ], nextTriggerDates)
            }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
