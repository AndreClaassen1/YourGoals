//
//  TestDataGeneratorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 25.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TestDataCreatorTests: StorageTestCase {

    /// test the artificial setted done state with a progress which corresponds to the size of the task
    func testSetDoneState() {
        // setup
        let goal = self.testDataCreator.createGoal(name: "Test Goal")
        let task = self.testDataCreator.createTask(name: "Done Task", forGoal: goal)
        let commitDate = Date.dateWithYear(2019, month: 06, day: 25)
        let beginTime = Date.timeWith(hour: 16, minute: 30, second: 00)
        let size:Float = 45.0
        
        // act
        self.testDataCreator.setDoneState(forTask: task, size: size, commitmentDate: commitDate, beginTime: beginTime)
        
        // test
        XCTAssertEqual(ActionableState.done, task.getTaskState())
        let progress = task.progress?.allObjects.first as! TaskProgress
        XCTAssertEqual(Date.dateTimeWithYear(2019, month: 06, day: 25, hour: 16, minute: 30, second: 00, timezoneIdentifier: nil), progress.start)
        XCTAssertEqual(Date.dateTimeWithYear(2019, month: 06, day: 25, hour: 17, minute: 15, second: 00, timezoneIdentifier: nil), progress.end)
    }

}
