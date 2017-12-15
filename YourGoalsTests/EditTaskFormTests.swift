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
    
    func testFormForTask() {
        // setup
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
   
        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)
        let _ = self.testDataCreator.createGoal(name: "Goal 2")
        let _ = self.testDataCreator.createGoal(name: "Goal 3")
        
        // act
        let editForm = try! EditTaskForm(manager: self.manager, goal: goal, actionable: task)
        let taskName:String? = editForm.item(tag: .taskTag).value
        
        // test
        XCTAssertEqual("A task which should be edited", taskName)
        XCTAssertEqual(3, (editForm.item(tag: .goalTag).options as [Goal]).count)
    }
}
