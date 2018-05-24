//
//  CommittedTasksDataSourceTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 09.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class CommittedTasksDataSourceTests: StorageTestCase {
    /// test the CommittedTasksDataSource with a backburned indicator and expected number of tasks as a result
    ///
    /// - Parameters:
    ///   - backburned: true, if tasks from backburned goals should be included
    ///   - expectedNumberOfTasks: expected number of tasks in the result set.
    func testBackburnedTasks(inclTasksFromBackburnedGoals backburned: Bool, expectedNumberOfTasks: Int) {
        // setup
        let testDate = Date.dateWithYear(2018, month: 05, day: 09)
        self.testDataCreator.generateTestData(startDate: testDate, data: [
            (goalName: "Regular Goal", backburned: false, numberOfTasks: 3),
            (goalName: "Backburned Goal", backburned: true, numberOfTasks: 4)
            ])
        
        // act
        let ds = CommittedTasksDataSource(manager: self.manager)
        let actionables = try! ds.fetchActionables(forDate: testDate, withBackburned: backburned, andSection: nil)
        
        // test
        XCTAssertEqual(expectedNumberOfTasks, actionables.count)
    }
    
    func testBackCommittedTasksInclBackburnedGoals() {
        testBackburnedTasks(inclTasksFromBackburnedGoals: true, expectedNumberOfTasks: 7)
    }
    
    func testBackCommittedTasksExclBackburnedGoals() {
        testBackburnedTasks(inclTasksFromBackburnedGoals: false, expectedNumberOfTasks: 3)
    }
}
