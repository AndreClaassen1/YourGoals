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
    
    /// generate valid test data with goals and tasks. you can specifiy, if a goal is backburned or not
    ///
    /// - Parameters:
    ///   - date: date for committed tasks
    ///   - data: testsdata with tuples of goalnames, backburned indicator and number of tasks for the goal
    func generateTestData(startDate date: Date, data: [(goalName:String, backburned: Bool, numberOfTasks: Int)]) {
        for d in data {
            let goal = self.testDataCreator.createGoal(name: d.goalName, backburned: d.backburned)
            for i in 0..<d.numberOfTasks {
                let task = self.testDataCreator.createTask(name: "Task #\(i) for Goal \(d.goalName)", forGoal: goal)
                task.commitmentDate = date
            }
        }
        
        try! self.manager.saveContext()
    }

    /// test the CommittedTasksDataSource with a backburned indicator and expected number of tasks as a result
    ///
    /// - Parameters:
    ///   - backburned: true, if tasks from backburned goals should be included
    ///   - expectedNumberOfTasks: expected number of tasks in the result set.
    func testBackburnedTasks(inclTasksFromBackburnedGoals backburned: Bool, expectedNumberOfTasks: Int) {
        // setup
        let testDate = Date.dateWithYear(2018, month: 05, day: 09)
        self.generateTestData(startDate: testDate, data: [
            (goalName: "Regular Goal", backburned: false, numberOfTasks: 3),
            (goalName: "Backburned Goal", backburned: true, numberOfTasks: 4)
            ])
        
        // act
        let ds = CommittedTasksDataSource(manager: self.manager, backburned: backburned)
        let actionables = try! ds.fetchActionables(forDate: testDate, andSection: nil)
        
        // test
        XCTAssertEqual(expectedNumberOfTasks, actionables.count)
    }
    
    func testBackCommittedTasksInclBackburnedGoals() {
        testBackburnedTasks(inclTasksFromBackburnedGoals: true, expectedNumberOfTasks: 7)
    }
    
    func testBackCommittedTasksExclBackburnedGoals() {
        testBackburnedTasks(inclTasksFromBackburnedGoals: false, expectedNumberOfTasks: 7)
    }
}
