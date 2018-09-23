//
//  TaskRepetitionManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 23.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
import CoreData
@testable import YourGoals

class TaskRepetitionManagerTests: StorageTestCase {

    var taskRepetitionManager:TaskRepetitionManager!
        
    override func setUp() {
        super.setUp()
        self.taskRepetitionManager = TaskRepetitionManager(manager: self.manager)
    }
    
    /// create a test task with state done in the storage
    ///
    /// - Parameters:
    ///   - doneDate: done date
    ///   - repetitions: the repetitions for the task
    /// - Returns: a valid object id
    func createDoneTask(doneDate:Date, withRepetitons repetitions:Set<ActionableRepetition>) -> NSManagedObjectID  {
        let factory = TaskFactory(manager: self.manager)
        let actionableInfo = ActionableInfo(type: .task, name: "This is a done task at 22.9.2018", commitDate: nil, parentGoal: nil, size: 3.0, repetitions: repetitions)
        
        // create a repetition task with is done saturday at 22.09.2018
        let task = factory.create(actionableInfo: actionableInfo) as! Task
        task.setTaskState(state: .done)
        task.doneDate = doneDate
        
        try! self.manager.saveContext()
        // get the real objectID after saving the task to the store
        let objectId = task.objectID
        return objectId
    }
    
    /// test the update repetition state function for a task
    /// which should be reactivated via a repetition
    func testUpdateRepetitionStateForActive() {
        // setup
        
        // the test date 23.9.2018 is a sunday
        let repetitions:Set<ActionableRepetition> = [.monday, .wednesday, .sunday]
        let testDate = Date.dateWithYear(2018, month: 09, day: 23)
        let objectId = createDoneTask(doneDate: Date.dateWithYear(2018, month: 09, day: 22), withRepetitons: repetitions)
        
        // act
        try! self.taskRepetitionManager.updateRepetitionState(forDate: testDate)
        
        // test
        let taskReloaded = self.manager.tasksStore.retrieveExistingObject(objectId: objectId)
        XCTAssertEqual(taskReloaded.getTaskState(), .active, "The task should be reopened")
        XCTAssertEqual(taskReloaded.doneDate, nil, "The task shouldn't have a done date")
    }
    
    /// test the update repetition state function for a task
    /// which shouldn't be reactivated via a repetition
    func testUpdateRepetitionStateForNotActive() {
        // setup
        let taskRepetitionManager = TaskRepetitionManager(manager: self.manager)
        let testDoneDate = Date.dateWithYear(2018, month: 09, day: 22)
        
        // the test date 23.9.2018 is a sunday
        let repetitions:Set<ActionableRepetition> = [.monday, .wednesday ]
        let testDate = Date.dateWithYear(2018, month: 09, day: 23)
        let objectId = createDoneTask(doneDate: testDoneDate, withRepetitons: repetitions)
        
        // act
        try! taskRepetitionManager.updateRepetitionState(forDate: testDate)
        
        // test
        let taskReloaded = self.manager.tasksStore.retrieveExistingObject(objectId: objectId)
        XCTAssertEqual(taskReloaded.getTaskState(), .done, "The task shouldn't be reopened")
        XCTAssertEqual(taskReloaded.doneDate, testDoneDate, "The task shouldn't have a done date")
    }
}
