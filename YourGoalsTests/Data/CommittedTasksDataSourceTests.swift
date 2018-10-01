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
    /// test the CommittedTasksDataSource with a backburnedGoals: indicator and expected number of tasks as a result
    ///
    /// - Parameters:
    ///   - backburnedGoals: true, if tasks from backburnedGoals: goals should be included
    ///   - expectedNumberOfTasks: expected number of tasks in the result set.
    func testBackburnedTasks(inclTasksFromBackburnedGoals backburnedGoals: Bool, expectedNumberOfTasks: Int) {
        // setup
        let testDate = Date.dateWithYear(2018, month: 05, day: 09)
        self.testDataCreator.generateTestData(startDate: testDate, data: [
            (goalName: "Regular Goal", backburnedGoals: false, numberOfTasks: 3),
            (goalName: "Backburned Goal", backburnedGoals: true, numberOfTasks: 4)
            ])
        
        // act
        let ds = CommittedTasksDataSource(manager: self.manager)
        let actionables = try! ds.fetchActionables(forDate: testDate, withBackburned: backburnedGoals, andSection: nil)
        
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
