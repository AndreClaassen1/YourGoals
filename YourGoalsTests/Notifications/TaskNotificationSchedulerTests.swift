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

/// Tests for the TaskNotificationScheduler
class TaskNotificationSchedulerTests: StorageTestCase {
    var progressManager:TaskProgressManager!
    var mockUserNotificationCenter:MockUserNotificationCenter!
    
    /// prepare the singletions
    override func setUp() {
        super.setUp()
        self.mockUserNotificationCenter = MockUserNotificationCenter()
        let taskNotificationScheduler = TaskNotificationScheduler(notificationCenter: self.mockUserNotificationCenter, observer: TaskNotificationObserver())
        self.progressManager = TaskProgressManager(manager: self.manager, taskNotificationProtocol: taskNotificationScheduler)
    }
    
    /// Given an task action
    /// when I start the task
    /// then I've got two local user notifications 5 minutes before the task end and when the task stops
    func testUserNotificationAtTaskStart(){
        
        let expectation = self.expectation(description: "pending notification")
        // Given an task action with a duration(size) of 30 Minutes
        let task = TaskFactory(manager: self.manager).create(name: "Task with started progress", state: .active, prio: 1, sizeInMinutes: 30.0)
        
        // date must be far in the future because next trigger date should be working
        let progressStartDate = Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 00, second: 00)
        
        // when I start the ask
        try! self.progressManager.startProgress(forTask: task, atDate: progressStartDate)
        
        // test
        self.mockUserNotificationCenter.getPendingNotificationRequests { (requests) in
            expectation.fulfill()
            let nextTriggerDates = requests.map { ($0.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()!  }
            XCTAssertEqual ( [
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 00, second: 10), // start notification your task is started
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 15, second: 00), // first notification 50%  of the task time is reached
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 20, second: 00), // second notification 10 minutes before task end
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 25, second: 00), // third notification 5 minutes before the tasks end
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 30, second: 00), // last notification at end of the task
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 35, second: 00), // 5 minutes overdue
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 40, second: 00), // 10 minutes overdue
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 45, second: 00), // 15 minutes overdue
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 00, second: 00), // 30 minutes overdue
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 15, second: 00), // 45 minutes overdue
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 30, second: 00), // 1 hour overdue
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 14, minute: 30, second: 00), // 2 hours overdue
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 15, minute: 30, second: 00), // 3 hours overdue and last reminder
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 16, minute: 30, second: 00), // 4 hours overdue and last reminder
                    Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 18, minute: 30, second: 00), // 6 hours overdue and last reminder
                ], nextTriggerDates)
            }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testTextForOverdueHours() {
        // setup
        let hours = 3
        let minutes = 0
        
        // act
        let text = TaskNotificationOverdueText.textForTaskOverrunning(hours: hours, minutes: minutes)
        
        // test
        XCTAssertLocalized("en", "You've overrun your task by 3 hours!" == text)
        XCTAssertLocalized("de-DE", "Du hast die Zeit deiner Aufgabe um 3 Stunden überzogen!" == text)
    }
    
    func testTextForOverdueMinutes() {
        // setup
        let hours = 0
        let minutes = 15
        
        // act
        let text = TaskNotificationOverdueText.textForTaskOverrunning(hours: hours, minutes: minutes)
        
        // test
        XCTAssertLocalized("en", "You've overrun your task by 15 minutes!" == text)
        XCTAssertLocalized("de-DE", "Du hast die Zeit deiner Aufgabe um 15 Minuten überzogen!" == text)
    }
    
    /// Given an task action which is progressing
    /// when I changed the progress and add 30 Minutes
    /// then I've got three local user notifications 5 minutes before the task end and when the task stops
    func testUserNotificationWithChangedProgress(){
        // prepare the singletions
        
        let expectation = self.expectation(description: "pending notification")
        
        // Given an task action with a duration(size) of 30 Minutes
        let task = TaskFactory(manager: self.manager).create(name: "Task with started progress", state: .active, prio: 1, sizeInMinutes: 30.0)
        // date must be far in the future because next trigger date should be working
        let progressStartDate = Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 00, second: 00)
        try! self.progressManager.startProgress(forTask: task, atDate: progressStartDate)

        // when I change after 10 Minutes progressing and add 30 Minutes
        let progressChangedTime = progressStartDate.addingTimeInterval(10.0 * 60.0)
        try! self.progressManager.changeTaskSize(forTask: task, delta: 30.0, forDate: progressChangedTime)
        
        // test
        mockUserNotificationCenter.getPendingNotificationRequests { (requests) in
            expectation.fulfill()
            let nextTriggerDates = requests.map { ($0.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()!  }
            XCTAssertEqual ( [
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 30, second: 00), // notification 50% of the task is done
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 50, second: 00), // first notification 10 minutes before task end
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 12, minute: 55, second: 00), // seconod notification 5 minutes before the tasks end
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 00, second: 00), // last notification at end of the task
                
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 05, second: 00), // 5 minutes overdue
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 10, second: 00), // 10 minutes overdue
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 15, second: 00), // 15 minutes overdue
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 30, second: 00), // 30 minutes overdue
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 13, minute: 45, second: 00), // 45 minutes overdue
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 14, minute: 00, second: 00), // 1 hour overdue
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 15, minute: 00, second: 00), // 2 hours overdue
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 16, minute: 00, second: 00), // 3 hours overdue and last reminder
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 17, minute: 00, second: 00), // 4 hours overdue and last reminder
                Date.dateTimeWithYear(2040, month: 04, day: 01, hour: 19, minute: 00, second: 00), // 6 hours overdue and last reminder

                ], nextTriggerDates)
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
