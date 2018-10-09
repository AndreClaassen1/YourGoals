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
    
    
    /// test if the algorithm for detecting intersection is working
    func testIsIntersecting() {
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.intersects(withDate: Date.dateWithYear(2017, month: 04, day: 01))
        
        XCTAssert(isIntersecting)
    }
    
    /// test if intersection returns false for a date/time after the timespan of the progress
    func testIsNotIntersectingAfter() {
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.intersects(withDate: Date.dateWithYear(2018, month: 04, day: 01))
        
        XCTAssertFalse(isIntersecting)
    }

    func testIsNotIntersectingBefore() {
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.intersects(withDate: Date.dateWithYear(2016, month: 04, day: 01))
        
        XCTAssertFalse(isIntersecting)
    }
    
    func testTimeIntervalWithFixedEndTime() {
        // setup
        let testDate = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 14, minute: 00, second: 00)
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        taskProgress.start = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 12, minute: 00, second: 00)
        taskProgress.end = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 13, minute: 00, second: 00)
        
        // act
        let progress = taskProgress.timeInterval(til: testDate)
        
        // test
        XCTAssertEqual(60 * 60, progress, "progress should be excat 1 jour")
    }
    
    func testTimeIntervalWithOpenEndTime() {
        // setup
        let testDate = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 14, minute: 00, second: 00)
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        taskProgress.start = Date.dateTimeWithYear(2017, month: 10, day: 30, hour: 12, minute: 00, second: 00)
        taskProgress.end = nil
        
        // act
        let progress = taskProgress.timeInterval(til: testDate)
        
        // test
        XCTAssertEqual(2 * 60 * 60, progress, "progress should be excat 2 hours")
    }
}
