//
//  EditTaskFormController.swift
//  YourGoals
//
//  Created by André Claaßen on 04.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

class EditTaskFormController : FormViewController, EditActionableViewControllerParameter {
    
    var goal:Goal!
    var editActionable:Actionable?
    var editActionableType:ActionableType?
    var delegate:EditActionableViewControllerDelegate?
    var manager:GoalsStorageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "New Task"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(cancelTapped(_:))
        
        self.initializeForm()
    }
    
    @objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
    
    private func initializeForm() {
        form +++
            Section()
            <<< TextRow("Task").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            
            <<< PushRow<Goal>() { row in
                row.title = "Select a Goal"
                row.options = userGoalsByPrio()
        }
        
        /// <<< Goal
        
        Section()
            <<< PushRow<String>() { row in
                row.title = "Select a commit date"
                row.options = ["Today", "tomorrow", "Tuesday"]
                
                /// <<< Commit for Day
                ///
                ///     Uncommit, Today, Tomorrow, Di, Mi,Do, Fr, Sa, Son
                ///     Schedule
                
                Section()
                    <<< TextAreaRow() {
                        $0.placeholder = "Remarks on your task"
                        $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                        
                        
                        
                }
        }
    }
    
    // Mark: - data helper methods
    
    /// retrieve an ordered list of goals for the strategy
    ///
    /// - Parameter goalTypes: goal types
    /// - Throws: an array of goals for the strategy
    func userGoalsByPrio() -> [Goal]  {
        do {
            let strategyOrderManager = StrategyOrderManager(manager: self.manager)
            return try strategyOrderManager.goalsByPrio(withTypes: [GoalType.userGoal] )
        }
        catch let error {
            showNotification(forError: error)
        }
        
        return []
    }
}
