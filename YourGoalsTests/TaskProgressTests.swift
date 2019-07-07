//
//  TaskProgressTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals


/// tests of the task progress core data class
class TaskProgressTests: StorageTestCase {
    
    var taskProgress:TaskProgress? = nil
    
    func createTaskProgress() -> TaskProgress {
        self.taskProgress = self.manager.taskProgressStore.createPersistentObject()
        return taskProgress!
    }
    
    override func tearDown() {
        if let taskProgress = self.taskProgress {
            self.manager.taskProgressStore.managedObjectContext.delete(taskProgress)
            try! self.manager.saveContext()
        }
    }
    
    /// test if the algorithm for detecting intersection is working
    func testIsIntersecting() {
        let taskProgress = createTaskProgress()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.intersects(withDate: Date.dateWithYear(2017, month: 04, day: 01))
        
        XCTAssert(isIntersecting)
    }
    
    /// test if intersection returns false for a date/time after the timespan of the progress
    func testIsNotIntersectingAfter() {
        let taskProgress = createTaskProgress()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.intersects(withDate: Date.dateWithYear(2018, month: 04, day: 01))
        
        XCTAssertFalse(isIntersecting)
    }

    func testIsNotIntersectingBefore() {
        let taskProgress = createTaskProgress()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.intersects(withDate: Date.dateWithYear(2016, month: 04, day: 01))
        
        XCTAssertFalse(isIntersecting)
    }
    
    func testTimeIntervalWithFixedEndTime() {
        // setup
        let testDate = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 14, minute: 00, second: 00)
        let taskProgress = createTaskProgress()
        taskProgress.start = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 12, minute: 00, second: 00)
        taskProgress.end = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 13, minute: 00, second: 00)
        
        // act
        let progress = taskProgress.timeInterval(til: testDate)
        
        // test
        XCTAssertEqual(60 * 60.0, progress, "progress should be excat 1 hour")
    }
    
    func testTimeIntervalWithOpenEndTime() {
        // setup
        let testDate = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 14, minute: 00, second: 00)
        let taskProgress = createTaskProgress()
        taskProgress.start = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 12, minute: 00, second: 00)
        taskProgress.end = nil
        
        // act
        let progress = taskProgress.timeInterval(til: testDate)
        
        // test
        XCTAssertEqual(2 * 60 * 60, progress, "progress should be excat 2 hours")
    }
    
    func testStartOfDayWithStartingDayOnDayBefore() {
        // setup
        let testDate = Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 09, minute: 00, second: 00)
        let taskProgress = createTaskProgress()
        taskProgress.start = Date.dateTimeWithYear(2019, month: 06, day: 30, hour: 13, minute: 00, second: 00) // task progress started the day before
        
        // act
        let startOfDay = taskProgress.startOfDay(day: testDate)
        
        // test
        XCTAssertEqual(Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 00, minute: 00, second: 00), startOfDay)
    }

    func testStartOfDayInDay() {
        // setup
        let testDate = Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 09, minute: 00, second: 00)
        let taskProgress = createTaskProgress()
        taskProgress.start = Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 13, minute: 00, second: 00) // task progress started one day after
        
        // act
        let startOfDay = taskProgress.startOfDay(day: testDate)
        
        // test
        XCTAssertEqual(Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 13, minute: 00, second: 00), startOfDay)
    }

    func testEndOfDayWithStartingDayOnDayAfter() {
        // setup
        let testDate = Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 09, minute: 00, second: 00)
        let taskProgress = createTaskProgress()
        taskProgress.end = Date.dateTimeWithYear(2019, month: 07, day: 02, hour: 13, minute: 00, second: 00) // task progress ending one day after
        
        // act
        let endOfDay = taskProgress.endOfDay(day: testDate)
        
        // test
        XCTAssertEqual(Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 23, minute: 59, second: 59), endOfDay)
    }
    
    func testEndOfDayInDay() {
        // setup
        let testDate = Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 09, minute: 00, second: 00)
        let taskProgress = createTaskProgress()
        taskProgress.end = Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 07, minute: 00, second: 00) // task progress started one day after
        
        // act
        let endOfDay = taskProgress.endOfDay(day: testDate)
        
        // test
        XCTAssertEqual(Date.dateTimeWithYear(2019, month: 07, day: 01, hour: 07, minute: 00, second: 00), endOfDay)
    }
}
