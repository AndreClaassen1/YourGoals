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
    
    /// parameter protocol for the EditActionableFormController. the parameter block is callend in prepareSegue
    var formParameter:EditActionableViewControllerParameter!
    
    /// the form controller which is under test
    var formVC:EditActionableFormController!
    
    /// the eureka form builder
    var form:Form!

    override func setUp() {
        // load the view to test the cells
        self.formVC = EditActionableFormController(style: .plain)
        self.formParameter = self.formVC
        self.form = formVC.form
        super.setUp()
    }
    
    /// set the parameter values of the vc and load it  with an existing
    /// actionable (.task or .habit) for editing
    ///
    /// - Parameter actionable: the actionable
    func loadController(with actionable: Actionable) {
        self.formParameter.editActionable = actionable
        self.formParameter.goal = actionable.goal
        self.formParameter.editActionableType = actionable.type
        self.commitParameterAndLoad()
    }
    
    /// set the parameter values of the vc adn load it for creating a new actionable
    /// (.task or .habit) for editng
    ///
    /// - Parameters:
    ///   - type: the type of the new actionable
    ///   - goal: the goal
    func loadController(newForType type: ActionableType, andGoal goal: Goal) {
        self.formParameter.editActionable = nil
        self.formParameter.goal = goal
        self.formParameter.editActionableType = type
        self.commitParameterAndLoad()
    }
    
    /// commit the parameter for the EditActionableFormController and
    /// load the form
    func commitParameterAndLoad() {
        self.formParameter.manager = self.manager
        self.formParameter.delegate = self
        self.formParameter.commitParameter()
        
        // this call triggers viewDidLoad()
        self.formVC.view.frame = CGRect(x: 0, y: 0, width: 375, height: 3000)
        self.formVC.tableView?.frame = formVC.view.frame
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
        self.loadController(with: task)
        
        // test get values
        let result = formVC.getActionableInfoFromValues(form: self.form)
        XCTAssertEqual("A task which should be edited", result.name)
        XCTAssertEqual(goal, result.parentGoal)
    }
    
    func testGoalOptions() {
        // setup
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form", prio: 1)
        let _ = self.testDataCreator.createGoal(name: "Goal 2", prio: 2)
        let _ = self.testDataCreator.createGoal(name: "Goal 3", prio: 3)
        let task = self.testDataCreator.createTask(name: "A task which should be edited", forGoal: goal)

        // act
        self.loadController(with: task)
        
        // test
        let rowGoal:PushRow<Goal> = self.form.rowBy(tag: TaskFormTag.goal)!
        let options = rowGoal.options!
        XCTAssertEqual(["Goal for the Edit Form", "Goal 2", "Goal 3"], options.map{ $0.name! })
    }

    func testFormForNewTask() {
        // setup
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form", prio: 1)

        // act
        self.loadController(newForType: .task, andGoal: goal)
        
        // test
        let actionableInfo = self.formVC.getActionableInfoFromValues(form: self.form)
        XCTAssertEqual(nil, actionableInfo.name)
    }
}
