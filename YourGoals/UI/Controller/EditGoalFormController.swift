//
//  EditGoalFormController.swift
//  YourGoals
//
//  Created by André Claaßen on 27.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

/// controller for editing an goal
class EditGoalFormController:FormViewController, EditGoalSegueParameter {
    var delegate: EditGoalFormControllerDelegate!
    var parameterCommitted = false
    var editGoal: Goal?
    
    func commit() {
        self.parameterCommitted = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = getTitle()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(cancelTapped(_:))
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(saveTapped(_:))
        
        let goalInfo = goalInfoFromParameter()
        self.configure(form: self.form, withInfo: goalInfo, newEntry: self.editGoal == nil, todayGoal: self.editGoal?.goalType() == .todayGoal)
    }
    
    /// create a goal info from the parameter passed to this controller
    ///
    /// - Returns: the goal info object ready to fill the rows of the form.
    func goalInfoFromParameter() -> GoalInfo {
        assert(self.parameterCommitted)
        if let goal = editGoal {
            return GoalInfo(goal: goal)
        } else {
            return GoalInfo()
        }
    }
    
    // Mark: - Eureka Callback function
    
    func deleteClicked() {
        assert(self.editGoal != nil)
        self.delegate.delete(goal: self.editGoal!)
        self.dismiss(animated: true,completion: {
            self.delegate?.dismissController()
        })
    }
    
    // MARK: Navigation Bar Methods
    
    /// the user aborts the editing of the actionable
    @objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    /// the user wants to save his edits
    @objc func saveTapped(_ barButtonItem: UIBarButtonItem) {
        let validationErrors = form.validate()
        guard validationErrors.count == 0 else {
            showNotification(forValidationErrors: validationErrors)
            return
        }
        
        let goalInfo = self.goalInfoFromValues(form: self.form)
        
        if let goal = self.editGoal  {
            delegate?.update(goal: goal, withGoalInfo: goalInfo)
        } else {
            delegate?.createNewGoal(goalInfo: goalInfo)
        }
        
        self.dismiss(animated: true)
    }
    
    /// create a title string depending on editing or creating an actionable
    ///
    /// - Returns: the title string
    func getTitle() -> String {
        let keyWord = self.editGoal == nil ? "New" : "Edit"
        
        return "\(keyWord) Goal"
    }
}
