//
//  EditTaskViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

protocol EditTaskViewControllerDelegate {
    func createNewTask(taskInfo: TaskInfo) throws
}

class EditTaskViewController: UIViewController {
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var taskTextView: UITextView!

    var delegate:EditTaskViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configureNewTask(forGoal goal:Goal) {
        goalLabel.text = "Goal: \(goal.name!)"
        taskTextView.text = ""
    }
    
    func taskInfoFromFields() throws -> TaskInfo? {
        if taskTextView.text.isEmpty {
            return nil
        }
        
        return try TaskInfo(taskName: taskTextView.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTaskAction(_ sender: Any) {
        do {
            guard let taskInfo = try taskInfoFromFields() else {
                self.showNotification(text: "Please enter neccessary fields and give a task name")
                return
            }
            
            try delegate?.createNewTask(taskInfo: taskInfo)
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
