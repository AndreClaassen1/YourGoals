//
//  TaskNotificationTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 26.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals


class TaskNotificationTests: StorageTestCase {
    
    /// Given an task action
    /// when I start the task
    /// then I've got two local user notifications 5 minutes before the task end and when the task stops
    func testUserNotificationAtTaskStart(){
        // prepare the singletions
        let expectation = self.expectation(description: "pending notification")
        let mockUserNotificationCenter = MockUserNotificationCenter()
        let taskNotificationManager = TaskNotificationManager(notificationCenter: mockUserNotificationCenter)
        let progressManager = TaskProgressManager(manager: self.manager, taskNotificationProtocol: taskNotificationManager)
        
        // Given an task action
        let task = TaskFactory(manager: self.manager).create(name: "Task with started progress", state: .active, prio: 1)
        let progressStartDate = Date.dateTimeWithYear(2018, month: 04, day: 01, hour: 12, minute: 00, second: 00)
        
        // when I start the ask
        try! progressManager.startProgress(forTask: task, atDate: progressStartDate)
        
        // test
        mockUserNotificationCenter.getPendingNotificationRequests { (requests) in
            expectation.fulfill()
            
            // then I've got two local user notification
            XCTAssertEqual(2, requests.count)
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
