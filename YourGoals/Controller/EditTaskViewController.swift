//
//  EditTaskViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData

protocol EditTaskViewControllerDelegate {
    func createNewTask(taskInfo: TaskInfo) throws
    func updateTask(taskInfo: TaskInfo, withId id: NSManagedObjectID) throws
    func deleteTask(taskWithId: NSManagedObjectID) throws
}

class EditTaskViewController: UIViewController {
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var taskSaveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteTaskButton: UIButton!
    
    var goal:Goal!
    var editTask:Task?
    var delegate:EditTaskViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskTextView.showBorder()
        self.configureTask(forGoal: self.goal, andTask: self.editTask)
        self.taskTextView.becomeFirstResponder()
    }
    
    func configureTask(forGoal goal:Goal, andTask task:Task?) {
        goalLabel.text = "Goal: \(goal.name!)"
        if let task = task {
            titleLabel.text = "Update Task"
            taskSaveButton.setTitle("Update task", for: .normal)
            taskTextView.text = task.name
            deleteTaskButton.isHidden = false
        } else {
            titleLabel.text = "New Task"
            taskSaveButton.setTitle("Add this task to my goal", for: .normal)
            taskTextView.text = ""
            deleteTaskButton.isHidden = true
        }
    }
    
    func taskInfoFromFields() throws -> TaskInfo? {
        if taskTextView.text.isEmpty {
            return nil
        }
        
        return try TaskInfo(taskName: taskTextView.text)
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
            try delegate?.deleteTask(taskWithId: editTask!.objectID)
            self.dismiss(animated: true, completion: nil)
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    @IBAction func saveTaskAction(_ sender: Any) {
        do {
            guard let taskInfo = try taskInfoFromFields() else {
                self.showNotification(text: "Please enter neccessary fields and give a task name")
                return
            }
            
            if editTask == nil {
                try delegate?.createNewTask(taskInfo: taskInfo)
            } else {
                try delegate?.updateTask(taskInfo: taskInfo, withId: editTask!.objectID)
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
