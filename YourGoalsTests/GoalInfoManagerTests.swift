//
//  GoalInfoManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class GoalInfoManagerTests: StorageTestCase {
    
    func testGoalsWithProgress() {
        // setup
        let factory = GoalFactory(manager: self.manager)
        let _ = try! factory.create(name: "Goal without progress", prio: 1, reason: "test", startDate: Date.dateWithYear(2017, month: 10, day: 30), targetDate: Date.dateWithYear(2017, month: 11, day: 01), image: nil)
        let goalWithProgress = try! factory.create(name: "Goal with progress", prio: 2, reason: "test", startDate: Date.dateWithYear(2017, month: 10, day: 30), targetDate: Date.dateWithYear(2017, month: 11, day: 01), image: nil)
        
        let taskFactory = TaskFactory(manager: self.manager)
        let task = taskFactory.create(name: "task with progress", state: .active, prio: 1)
        goalWithProgress.addToTasks(task)
        
        let taskProgressManager = TaskProgressManager(manager: self.manager)
        try! taskProgressManager.startProgress(forTask: task, atDate: Date.dateWithYear(2017, month: 10, day: 31))
        try! self.manager.dataManager.saveContext()
        
        // act
        let goalInfoManager = GoalInfoManager(manager: self.manager)
        let goalsWithProgress = try! goalInfoManager.retrieveGoalsWithProgress()
        
        // test
        XCTAssertEqual(1, goalsWithProgress.count)
        XCTAssertEqual("Goal with progress", goalsWithProgress[0].name)
    }
}
