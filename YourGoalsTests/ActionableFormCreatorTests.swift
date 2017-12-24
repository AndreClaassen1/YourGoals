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
    
    var formVC:FormViewController!
    
    override func setUp() {
        // load the view to test the cells
        self.formVC = FormViewController()
        formVC.view.frame = CGRect(x: 0, y: 0, width: 375, height: 3000)
        formVC.tableView?.frame = formVC.view.frame
        super.setUp()
    }
    
    func testFormForExistingTask() {
        // setup
        // load the view to test the cells
        let testDate = Date.dateWithYear(2017, month: 12, day: 19)
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)
        
        // act
        let creator = ActionableFormCreator(form: formVC.form, forType: .task, newEntry: false, manager: self.manager)
        creator.createForm()
        creator.setValues(for: ActionableInfo(actionable: task), forDate: testDate)
        
        // test get values
        let actionableInfo = creator.getActionableInfoFromValues()
        XCTAssertEqual("A task which should be edited", actionableInfo.name)
        XCTAssertEqual(goal, actionableInfo.parentGoal)
    }
    
    func testGoalOptions() {
        // setup
        let testDate = Date.dateWithYear(2017, month: 12, day: 19)
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form", prio: 1)
        let _ = self.testDataCreator.createGoal(name: "Goal 2", prio: 2)
        let _ = self.testDataCreator.createGoal(name: "Goal 3", prio: 3)
        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)
        
        // act
        let creator = ActionableFormCreator(form: formVC.form, forType: .task, newEntry: false, manager: self.manager)
        creator.createForm()
        creator.setValues(for: ActionableInfo(actionable: task), forDate: testDate)
        
        // test
        let rowGoal:PushRow<Goal> = self.formVC.form.rowBy(tag: EditTaskFormTag.goalTag.rawValue)!
        let options = rowGoal.options!
        XCTAssertEqual(["Goal for the Edit Form", "Goal 2", "Goal 3"], options.map{ $0.name! })
    }
    
    func testFormForNewTask() {
        // setup
        let testDate = Date.dateWithYear(2017, month: 12, day: 19)

        // act
        let creator = ActionableFormCreator(form: formVC.form, forType: .task, newEntry: true, manager: self.manager)
        creator.createForm()
        creator.setValues(for: ActionableInfo(type: .task, name: nil), forDate: testDate)
        
        // test
        let actionableInfo = creator.getActionableInfoFromValues()
        XCTAssertEqual(nil, actionableInfo.name)
    }
}
