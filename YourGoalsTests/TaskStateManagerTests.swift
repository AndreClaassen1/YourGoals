//
//  TaskStateManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TaskStateManagerTests: StorageTestCase {
    
    func testStateDone() {
        // setup
        let task = TaskFactory(manager: self.manager).create(name: "Active Task", state: .active)
        try! self.manager.dataManager.saveContext()
        let id = task.objectID
        let stateManager = TaskStateManager(manager: self.manager)
        
        // act
        try! stateManager.setTaskState(task: task, state: .done, atDate: Date.dateWithYear(2017, month: 10, day: 25))
        
        // test
        let taskReloaded = self.manager.tasksStore.retrieveExistingObject(objectId: id)
        XCTAssertEqual(.done, taskReloaded.getTaskState())
    }
}
