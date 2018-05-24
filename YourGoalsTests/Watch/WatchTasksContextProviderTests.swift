//
//  WatchTasksContextProviderTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class WatchTasksContextProviderTests: StorageTestCase {
    
    func testTodayTasksWithoutBackburned() {
     
        // setup
        let testDate = Date.dateWithYear(2018, month: 05, day: 24)
        self.testDataCreator.generateTestData(startDate: testDate, data: [
            (goalName: "Regular Goal", backburned: false, numberOfTasks: 3),
            (goalName: "Backburned Goal", backburned: true, numberOfTasks: 4)
            ])
        
        let wcp = WatchTasksContextProvider(manager: self.manager)
        
        // act
        let watchTasks = try! wcp.todayTasks(referenceDate: testDate, withBackburned: false)
    
        // test
        XCTAssertEqual(3, watchTasks.count)
    }
}
