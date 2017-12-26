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
class EditActionableFormControllerTests: StorageTestCase, EditActionableViewControllerDelegate {
    
    
    var formParameter:EditActionableViewControllerParameter!
    var formVC:EditActionableFormController!
    var form:Form!

    
    
    override func setUp() {
        // load the view to test the cells
        self.formVC = EditActionableFormController(style: .plain)
        self.formParameter = self.formVC
        self.form = formVC.form
        super.setUp()
    }
    
    func loadForm() {
        formVC.view.frame = CGRect(x: 0, y: 0, width: 375, height: 3000)
        formVC.tableView?.frame = formVC.view.frame
    }
    
    // Mark: Edit Actionable Form Delegate
    
    func createNewActionable(actionableInfo: ActionableInfo) throws {
    }
    
    func updateActionable(actionable: Actionable, updateInfo: ActionableInfo) throws {
    }
    
    func deleteActionable(actionable: Actionable) throws {
    }
    
    // Mark: Test methods
    
    func testFormForExistingTask() {
        // setup
        // load the view to test the cells
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)
        
        // act
        self.formParameter.editActionable = task
        self.formParameter.goal = goal
        self.formParameter.editActionableType = .task
        self.formParameter.manager = self.manager
        self.formParameter.delegate = self
        self.formParameter.commitParameter()
        self.loadForm()
        
        // test get values
        let result = formVC.getActionableInfoFromValues(form: self.form)
        XCTAssertEqual("A task which should be edited", result.name)
        XCTAssertEqual(goal, result.parentGoal)
    }
    
//    func testGoalOptions() {
//        // setup
//        let testDate = Date.dateWithYear(2017, month: 12, day: 19)
//        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form", prio: 1)
//        let _ = self.testDataCreator.createGoal(name: "Goal 2", prio: 2)
//        let _ = self.testDataCreator.createGoal(name: "Goal 3", prio: 3)
//        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)
//
//        // act
//        let creator = ActionableFormCreator(form: formVC.form, forType: .task, newEntry: false, manager: self.manager)
//        creator.createForm()
//        creator.setValues(for: ActionableInfo(actionable: task), forDate: testDate)
//
//        // test
//        let rowGoal:PushRow<Goal> = self.formVC.form.rowBy(tag: EditTaskFormTag.goalTag.rawValue)!
//        let options = rowGoal.options!
//        XCTAssertEqual(["Goal for the Edit Form", "Goal 2", "Goal 3"], options.map{ $0.name! })
//    }
//
//    func testFormForNewTask() {
//        // setup
//        let testDate = Date.dateWithYear(2017, month: 12, day: 19)
//
//        // act
//        let creator = ActionableFormCreator(form: formVC.form, forType: .task, newEntry: true, manager: self.manager)
//        creator.createForm()
//        creator.setValues(for: ActionableInfo(type: .task, name: nil), forDate: testDate)
//
//        // test
//        let actionableInfo = creator.getActionableInfoFromValues()
//        XCTAssertEqual(nil, actionableInfo.name)
//    }
}
