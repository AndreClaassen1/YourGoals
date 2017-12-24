//
//  EditActionableFormController.swift
//  YourGoals
//
//  Created by André Claaßen on 04.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

protocol EditActionableViewControllerDelegate {
    func createNewActionable(actionableInfo: ActionableInfo) throws
    func updateActionable(actionable: Actionable,  updateInfo: ActionableInfo) throws
    func deleteActionable(actionable: Actionable) throws
}

protocol EditActionableViewControllerParameter {
    var manager:GoalsStorageManager! { get set }
    var goal:Goal! { get set }
    var editActionable:Actionable? { get set }
    var editActionableType:ActionableType! { get set }
    var delegate:EditActionableViewControllerDelegate? { get set }
    func commitParameter()
}

/// new form controller for editing tasks and habits based on eureka
class EditActionableFormController : FormViewController, EditActionableViewControllerParameter {
    var goal:Goal!
    var editActionable:Actionable?
    var editActionableType:ActionableType!
    var delegate:EditActionableViewControllerDelegate?
    var manager:GoalsStorageManager!
    var parameterCommitted = false
    
    func commitParameter() {
        assert(self.manager != nil)
        assert(self.delegate != nil)
        assert(self.goal != nil)
        assert(self.editActionableType != nil)
        if editActionable != nil {
            assert(self.editActionable?.type == self.editActionableType)
        }
        
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
        
        ///self.createForm(withViewModel: viewModel)
        
        let formCreator = ActionableFormCreator(form: self.form, forType: self.editActionableType, newEntry: self.editActionable == nil, manager: self.manager)
        let startingDateForCommits = Date()
        let actionableInfo = actionableInfoFromParameter()
        formCreator.createForm()
        formCreator.setValues(for: actionableInfo, forDate: startingDateForCommits)
    }
    
    func actionableInfoFromParameter() -> ActionableInfo {
        if let actionable = self.editActionable {
            return ActionableInfo(actionable: actionable)
        } else {
            return ActionableInfo(type: self.editActionableType, name: nil, commitDate: nil, parentGoal: self.goal)
        }
    }
    
    // MARK: Navigation Bar Button Events
    
    @objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func saveTapped(_ barButtonItem: UIBarButtonItem) {
        do {
            
            let validationErrors = form.validate()
            guard validationErrors.count == 0 else {
                showNotification(text: "There are validation errors")
                return
            }
            
            guard let actionableInfo = actionableInfoFromFields() else {
                showNotification(text: "Bug: Could not create a task or habit")
                return
            }
            
            if let actionable = self.editActionable  {
                try delegate?.updateActionable(actionable: actionable, updateInfo: actionableInfo)
            } else {
                try delegate?.createNewActionable(actionableInfo: actionableInfo)
            }
            
            self.dismiss(animated: true)
        }
        catch let error {
            NSLog("could not create a new task info from fields. \(error.localizedDescription)")
            self.showNotification(forError: error)
        }
    }
    
    func actionableInfoFromFields() -> ActionableInfo? {
        let row:TextRow = self.form.rowBy(tag: EditTaskFormTag.taskTag.rawValue)!
        guard let name = row.value else {
            fatalError("couldn't read name of task or habit")
        }
   
        guard let rowGoal:PushRow<Goal> = self.form.rowBy(tag: EditTaskFormTag.goalTag.rawValue) else {
            fatalError("couldn't extract row for Goal")
        }
        
        let parentGoal = rowGoal.value
        
        var commitDate:Date? = nil
        
        if self.editActionableType == .task {
            guard let rowCommitDate:PushRow<CommitDateTuple> = self.form.rowBy(tag: EditTaskFormTag.commitDateTag.rawValue) else {
                fatalError("couldn't extract row by commit date")
            }
            
            commitDate = rowCommitDate.value?.date
        }
        
        return ActionableInfo(type: editActionableType!, name: name, commitDate: commitDate, parentGoal: parentGoal)
    }
    
    /// create a title string depending on editing or creating an actionable
    ///
    /// - Returns: the title string
    func getTitle() -> String {
        let keyWord = editActionable == nil ? "New" : "Edit"
        
        return "\(keyWord) \(editActionableType.asString())"
    }
    
    // Mark: - data helper methods
}
