//
//  EditActionableViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData

protocol EditActionableViewControllerDelegate {
    func createNewActionable(actionableInfo: ActionableInfo) throws
    func updateActionable(actionable: Actionable,  updateInfo: ActionableInfo) throws
    func deleteActionable(actionable: Actionable) throws
}

class EditActionableViewController: UIViewController {
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var taskSaveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteTaskButton: UIButton!
    
    var goal:Goal!
    var editActionable:Actionable?
    var editActionableType:ActionableType?
    var delegate:EditActionableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskTextView.showBorder()
        
        guard let type = self.editActionableType else {
            assertionFailure("editActionableType wasn't set")
            return
        }
        
        self.configureTask(forGoal: self.goal, andActionable: self.editActionable, andType: type)
        self.taskTextView.becomeFirstResponder()
    }
    
    func configureTask(forGoal goal:Goal, andActionable actionable: Actionable?, andType type: ActionableType) {
        goalLabel.text = "Goal: \(goal.name!)"
        if let actionable = actionable {
            titleLabel.text = "Update " + actionable.type.asString()
            taskSaveButton.setTitle("Update", for: .normal)
            taskTextView.text = actionable.name
            deleteTaskButton.isHidden = false
        } else {
            titleLabel.text = "New " + type.asString()
            taskSaveButton.setTitle("Add this task to my goal", for: .normal)
            taskTextView.text = ""
            deleteTaskButton.isHidden = true
        }
    }
    
    func taskInfoFromFields() -> ActionableInfo? {
        if taskTextView.text.isEmpty {
            return nil
        }
        
        return ActionableInfo(type: self.editActionableType!, name: taskTextView.text)
    }

    @IBAction func closerAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteTaskAction(_ sender: Any) {
        do {
            guard let actionable = self.editActionable else {
                NSLog("could not get the instance of the actionable")
                return
            }
            
            try delegate?.deleteActionable(actionable: actionable)
            self.dismiss(animated: true, completion: nil)
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    @IBAction func saveTaskAction(_ sender: Any) {
        do {
            guard let actionableInfo = taskInfoFromFields() else {
                self.showNotification(text: "Please enter neccessary fields and give a task name")
                return
            }
            
            if let actionable = self.editActionable  {
                try delegate?.updateActionable(actionable: actionable, updateInfo: actionableInfo)
            } else {
                try delegate?.createNewActionable(actionableInfo: actionableInfo)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        catch let error {
            NSLog("could not create a new task info from fields. \(error.localizedDescription)")
            self.showNotification(forError: error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
