//
//  TodayWorkloadInfoTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 08.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TodayWorkloadInfoTests: StorageTestCase {
    
    func testWorkLoad() {
        // setup
        
        let commitmentDate = Date.dateWithYear(2018, month: 01, day: 08)
        let workloadDate = Date.dateTimeWithYear(2018, month: 01, day: 08, hour: 13, minute: 00, second: 00)
        let _ = super.testDataCreator.createGoalWithTasks(infos: [
                ("Task 30 Minutes", 1, 30.0, commitmentDate, nil),
                ("Task 90 Minutes", 2, 90.0, commitmentDate, nil),
                ("Task not committed", 2, 90.0, nil, nil)
            ])
        
        // act
        let info = try! TodayWorkloadCalculator(manager: self.manager).calcWorkload(forDate: workloadDate, backburnedGoals: true)
    
        // test
        XCTAssertEqual(2, info.totalTasksLeft)
        XCTAssertEqual(120 * 60.0, info.totalRemainingTime, accuracy: 0.1)
        XCTAssertEqual(workloadDate.addingTimeInterval(info.totalRemainingTime).timeIntervalSince(commitmentDate), info.endTime.timeIntervalSince(commitmentDate), accuracy: 0.1)
    }
}
