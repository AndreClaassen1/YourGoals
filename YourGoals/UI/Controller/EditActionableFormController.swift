//
//  EditActionableFormController.swift
//  YourGoals
//
//  Created by André Claaßen on 04.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

/// actions created by the user for this form (CRUD)
protocol EditActionableViewControllerDelegate {
    func createNewActionable(actionableInfo: ActionableInfo) throws
    func updateActionable(actionable: Actionable,  updateInfo: ActionableInfo) throws
    func deleteActionable(actionable: Actionable) throws
}

/// parameter block for the form. the parameter will be set in the prepare segue call
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
    
    /// true, if the actionable is a new record
    func isNewActionable() -> Bool {
        return editActionable == nil
    }
    
    /// end of transfering parameter to the view controller
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
    
    /// load the view 
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
        
        let actionableInfo = actionableInfoFromParameter()
        configure(form: self.form, withInfo: actionableInfo, newEntry: self.editActionable == nil, forDate: Date())
    }
    
    /// create an actionable info from the parameters for the form
    ///
    /// - Returns: the actionable ifo
    func actionableInfoFromParameter() -> ActionableInfo {
        if let actionable = self.editActionable {
            return ActionableInfo(actionable: actionable)
        } else {
            return ActionableInfo(type: self.editActionableType, name: nil, commitDate: nil, parentGoal: self.goal)
        }
    }
    
    // MARK: Navigation Bar Button Events
    
    /// the user aborts the editing of the actionable
    @objc func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    /// the user wants to save his edits
    @objc func saveTapped(_ barButtonItem: UIBarButtonItem) {
        do {
            let validationErrors = form.validate()
            guard validationErrors.count == 0 else {
                showNotification(text: "There are validation errors")
                return
            }
            
            let actionableInfo = self.getActionableInfoFromValues(form: self.form)
            
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
    
    /// create a title string depending on editing or creating an actionable
    ///
    /// - Returns: the title string
    func getTitle() -> String {
        let keyWord = editActionable == nil ? "New" : "Edit"
        
        return "\(keyWord) \(editActionableType.asString())"
    }
    
    // MARK: - Call Back from Eureka Extension
    
    /// handle the click of the delete button.
    func deleteClicked() {
        do {
            guard let actionable = self.editActionable else {
                fatalError("editActionable is nil")
            }
            
            try self.delegate?.deleteActionable(actionable: actionable)
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
}
