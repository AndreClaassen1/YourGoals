//
//  EditGoalViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData



class EditGoalViewController: UIViewController, EditGoalSegueParameter {
    @IBOutlet weak var goalNameField: UITextField!
    @IBOutlet weak var reasonField: UITextView!
    @IBOutlet weak var targetDatePicker: UIDatePicker!
    @IBOutlet weak var goalImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteGoalButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var delegate:EditGoalFormControllerDelegate!
    var editGoal:Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonField.showBorder()
        
        // Do any additional setup after loading the view.
        
        configureGoal(withGoal: self.editGoal)
        configureImagePicker(imagePicker: self.imagePicker)
    }
    
    func commit() {
        assert(delegate != nil)
    }
    
    func configureGoal(withGoal goal:Goal?) {
        if let goal = goal {
            self.titleLabel.text = "Edit Goal"
            self.goalNameField.text = goal.name
            self.reasonField.text = goal.reason
            self.deleteGoalButton.isHidden = false
            if let data = goal.imageData?.data  {
                self.goalImageButton.setImage(UIImage(data: data), for: .normal)
            }
            else {
                self.goalImageButton.setImage(UIImage(named: "Success"), for: .normal)
            }
        
        } else {
            self.goalImageButton.setImage(UIImage(named: "Success"), for: .normal)
            self.titleLabel.text = "New Goal"
            self.goalNameField.text = ""
            self.reasonField.text = ""
            self.deleteGoalButton.isHidden = true
            self.goalNameField.becomeFirstResponder()
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
        let image = self.goalImageButton.image(for: .normal)
        
        return GoalInfo(name: goalName, reason: reason, startDate: Date(), targetDate: targetDate, image:image)
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
    
    @IBAction func deleteGoalAction(_ sender: Any) {
        self.delegate?.delete(goal: self.editGoal!)
        self.dismiss(animated: true,completion: {
            self.delegate?.dismissController()
        })
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
