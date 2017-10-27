//
//  TaskProgressTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals


class TaskProgressTests: StorageTestCase {
    
    
    func testIsIntersecting() {
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.isIntersecting(withDate: Date.dateWithYear(2017, month: 04, day: 01))
        
        XCTAssert(isIntersecting)
    }
    
    func testIsNotIntersecting() {
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        
        let isIntersecting = taskProgress.isIntersecting(withDate: Date.dateWithYear(2018, month: 04, day: 01))
        
        XCTAssertFalse(isIntersecting)
    }

    
}
