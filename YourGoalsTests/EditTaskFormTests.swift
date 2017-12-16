//
//  EditTaskFormTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 11.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

/// tests of the MVVM object EditTaskFor
class EditTaskFormTests: StorageTestCase {
    
    func testFormForExistingTask() {
        // setup
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
        let _ = self.testDataCreator.createGoal(name: "Goal 2")
        let _ = self.testDataCreator.createGoal(name: "Goal 3")
        
        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)

        // act
        let creator = ActionableViewModelCreator(manager: self.manager)
        let editForm = try! creator.createViewModel(for: task)
        let taskName:String? = editForm.item(tag: EditTaskFormTag.taskTag.rawValue).value
        let title:String? = editForm.item(tag: EditTaskFormTag.titleTag.rawValue).value
        
        // test
        XCTAssertEqual("Edit Task", title)
        XCTAssertEqual("A task which should be edited", taskName)
        XCTAssertEqual(3, (editForm.item(tag: EditTaskFormTag.goalTag.rawValue).options as [Goal]).count)
    }
    
    func testFormForNewTask() {
        // setup
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
        
        // act
        let creator = ActionableViewModelCreator(manager: self.manager)
        let editForm = try! creator.createViewModel(for: goal, andType: .task)
        let title:String? = editForm.item(tag: EditTaskFormTag.titleTag.rawValue).value
        
        // test
        XCTAssertEqual("New Task", title)
        XCTAssertEqual(1, (editForm.item(tag: EditTaskFormTag.goalTag.rawValue).options as [Goal]).count)
    }
}
