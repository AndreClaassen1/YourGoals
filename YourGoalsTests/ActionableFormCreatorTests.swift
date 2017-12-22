//
//  EditTaskFormTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 11.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
import Eureka
@testable import YourGoals

/// tests of the MVVM object EditTaskFor
class ActionableFormCreatorTests: StorageTestCase {
    
    func testFormForExistingTask() {
        // setup
        // load the view to test the cells
        let formVC = FormViewController()
        formVC.view.frame = CGRect(x: 0, y: 0, width: 375, height: 3000)
        formVC.tableView?.frame = formVC.view.frame
        
        let testDate = Date.dateWithYear(2017, month: 12, day: 19)
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
        let _ = self.testDataCreator.createGoal(name: "Goal 2")
        let _ = self.testDataCreator.createGoal(name: "Goal 3")
        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)
        
        // act
        let creator = ActionableFormCreator(form: formVC.form, manager: self.manager)
        creator.createForm(for: task, atDate: testDate)
        
        // test
        let values = formVC.form.values()
        XCTAssertEqual("A task which should be edited", values[EditTaskFormTag.taskTag.rawValue]! as! String?)
        XCTAssertEqual(goal, values[EditTaskFormTag.goalTag.rawValue]! as! Goal?)
    }
    
//    func testFormForNewTask() {
//        // setup
//        let testDate = Date.dateWithYear(2017, month: 12, day: 19)
//        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
//
//        // act
//        let creator = ActionableViewModelCreator(manager: self.manager)
//        let editForm = try! creator.createViewModel(for: goal, andType: .task, atDate: testDate)
//        let title:String? = editForm.item(tag: EditTaskFormTag.titleTag.rawValue).value
//
//        // test
//        XCTAssertEqual("New Task", title)
//        XCTAssertEqual(1, (editForm.item(tag: EditTaskFormTag.goalTag.rawValue).options as [Goal]).count)
//    }
}
