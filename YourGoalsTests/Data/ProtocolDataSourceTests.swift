//
//  ProtocolDataSourceTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 10.07.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class ProtocolDataSourceTests: StorageTestCase {
    
    var protocolDataSource:ProtocolDataSource!
    
    override func setUp() {
        super.setUp()
        self.protocolDataSource = ProtocolDataSource(manager: self.manager)
    }
    
    func testDataSource() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 09, day: 25)
        let progressStart = referenceDate.addMinutesToDate(10*60) // progress starts at 10:00 am
        let progressEnd = progressStart.addMinutesToDate(60)
        
        let goalWorked = self.testDataCreator.createGoal(name: "Test Goal with work")
        let taskWithProgress = self.testDataCreator.createTask(name: "Task with progress", commitmentDate: referenceDate, forGoal: goalWorked)
        self.testDataCreator.createProgress(forTask: taskWithProgress, start: progressStart, end: progressEnd)
        
        // act
        let protocolGoalInfos = try! self.protocolDataSource.fetchWorkedGoals(forDate: referenceDate)
        
        // test
        XCTAssertEqual(1, protocolGoalInfos.count)
    }
}
