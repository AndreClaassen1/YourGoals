//
//  EditGoalControllerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 29.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
import Eureka
@testable import YourGoals

class EditGoalControllerTests: StorageTestCase, EditGoalFormControllerDelegate {
    
    /// parameter protocol for the EditActionableFormController. the parameter block is callend in prepareSegue
    var formParameter:EditGoalSegueParameter!
    
    /// the form controller which is under test
    var formVC:EditGoalFormController!
    
    /// the eureka form builder
    var form:Form!
    
    override func setUp() {
        // load the view to test the cells
        self.formVC = EditGoalFormController(style: .plain)
        self.formParameter = self.formVC
        self.form = formVC.form
        super.setUp()
    }
    
    /// set the parameter values of the vc and load it  with an existing
    /// actionable (.task or .habit) for editing
    ///
    /// - Parameter actionable: the actionable
    func loadController(with goal: Goal?) {
        // self.formParameter.manager = self.manager
        self.formParameter.editGoal = goal
        self.formParameter.delegate = self
        self.formParameter.commit()
        
        // this call triggers viewDidLoad()
        self.formVC.view.frame = CGRect(x: 0, y: 0, width: 375, height: 3000)
        self.formVC.tableView?.frame = formVC.view.frame
    }
    
    // Mark: EditGoalFormControllerDelegate
    
    func createNewGoal(goalInfo: GoalInfo) {
        
    }
    
    func update(goal: Goal, withGoalInfo goalInfo: GoalInfo) {
        
    }
    
    func delete(goal: Goal) {
        
    }
    
    func dismissController() {
        
    }
    
    // Mark: Test Methods
    
    func testEditGoal() {
        //setup
        let goal = self.testDataCreator.createGoal(name: "Goal for the Edit Form")
        
        // act
        self.loadController(with: goal)
        
        // tests
        let result = self.formVC.goalInfoFromValues(form: self.form)
        XCTAssertEqual("Goal for the Edit Form", result.name)
    }
    
    func testTodayGoal() {
        //setup
        let strategyManager = StrategyManager(manager: self.manager)
        let todayGoal = try! strategyManager.assertTodayGoal(strategy: try! strategyManager.assertValidActiveStrategy())
        
        // act
        self.loadController(with: todayGoal)
        
        // tests the hidden buttons
        XCTAssert(self.form.rowBy(tag: GoalFormTag.startDate)!.isHidden)
        XCTAssert(self.form.rowBy(tag: GoalFormTag.targetDate)!.isHidden)
        XCTAssert(self.form.rowBy(tag: GoalFormTag.deleteButton)!.isHidden)
    }
}
