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
    var parameterCommitted = false
    
    func commitParameter() {
        assert(self.manager != nil)
        assert(self.delegate != nil)
        assert(self.goal != nil)
        assert(self.editActionableType != nil)
        assert(self.editActionableType == .task)
        if editActionable != nil {
            assert(self.editActionable?.type == self.editActionableType)
        }
        
        self.parameterCommitted = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "New Task"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(cancelTapped(_:))
        
        do {
            let viewModel = try EditTaskForm(manager: self.manager, goal: self.goal, actionable: self.editActionable)
            self.createForm(withViewModel: viewModel)
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    @objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
    
    private func createForm(withViewModel viewModel:EditTaskForm) {
        assert(self.parameterCommitted, "The parameter weren't committed")
        form +++
            Section()
            <<< TextRow(tag: EditTaskFormTag.taskTag.rawValue).cellSetup { cell, row in
                cell.textField.placeholder = row.tag
                row.value = viewModel.item(tag: row.tag).value
            }
            
            <<< PushRow<Goal>(EditTaskFormTag.goalTag.rawValue) { row in
                row.title = "Select a Goal"
                let goalItem:TypedFormItem<Goal> = viewModel.item(tag: .goalTag) as TypedFormItem<Goal>
                row.value = goalItem.value
                row.options = goalItem.options
                }.onPresent{ (_, to) in
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel?.text = row.selectableValue?.name
                    }
                }.cellUpdate{ (cell, row) in
                    cell.textLabel?.text = "Goal"
                    cell.detailTextLabel?.text = row.value?.name
                }
            Section()
                <<< PushRow<String>() { row in
                row.tag = EditTaskFormTag.commitDateTag.rawValue
                row.title = "Select a commit date"
                row.options = ["Today", "tomorrow", "Tuesday"]
                
                /// <<< Commit for Day
                ///
                ///     Uncommit, Today, Tomorrow, Di, Mi,Do, Fr, Sa, Son
                ///     Schedule
                }
            Section()
                <<< TextAreaRow() {
                        $0.placeholder = "Remarks on your task"
                        $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                }
    }
    
    // Mark: - data helper methods
}
