//
//  EditGoalViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData

protocol EditGoalViewControllerDelegate {
    func createNewGoal(goalInfo: GoalInfo)
    func update(goal:Goal, withGoalInfo goalInfo:GoalInfo)
}

class EditGoalViewController: UIViewController {
    @IBOutlet weak var goalNameField: UITextField!
    @IBOutlet weak var reasonField: UITextView!
    @IBOutlet weak var targetDatePicker: UIDatePicker!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    let imagePicker = UIImagePickerController()
    var delegate:EditGoalViewControllerDelegate?
    var editGoal:Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonField.showBorder()
        
        // Do any additional setup after loading the view.
        
        configureGoal(withGoal: self.editGoal)
        configureImagePicker(imagePicker: self.imagePicker)
        self.goalNameField.becomeFirstResponder()   
    }
    
    func configureGoal(withGoal goal:Goal?) {
        if let goal = goal {
            self.titleLabel.text = "Edit Goal"
            self.goalNameField.text = goal.name
            self.reasonField.text = goal.reason
            if let data = goal.imageData?.data  {
                self.goalImageView.image = UIImage(data: data)
            }
            else {
                self.goalImageView.image = nil
            }
        
        } else {
            self.titleLabel.text = "New Goal"
            self.goalNameField.text = ""
            self.reasonField.text = ""
        }
        self.targetDatePicker.date = Date().addDaysToDate(30)
    }

    /// create a goal info from the input fields
    ///
    /// - Returns: a valid GoalInfo structure
    /// - Throws: field check errors
    func goalInfoFromFields() throws -> GoalInfo {
        guard let goalName = goalNameField.text else {
            throw FieldCheckError.invalidInput(field: "goal", hint: "You must specify a goal")
        }
        
        let reason = reasonField.text ?? ""
        let targetDate = targetDatePicker.date
        let image = goalImageView.image
        
        return try GoalInfo(name: goalName, reason: reason, startDate: Date(), targetDate: targetDate, image:image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closerAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectNewImageAction(_ sender: Any) {
        selectImageFromPicker(imagePicker: self.imagePicker)
    }
    
    @IBAction func saveGoalAction(_ sender: Any) {
        do {
            let goalInfo = try goalInfoFromFields()
            if self.editGoal != nil {
                delegate?.update(goal: self.editGoal!, withGoalInfo: goalInfo)
            } else {
                delegate?.createNewGoal(goalInfo: goalInfo)
            }
            self.dismiss(animated: true)
        }
        catch let error {
            NSLog("could not create a goal info from fields. \(error.localizedDescription)")
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
