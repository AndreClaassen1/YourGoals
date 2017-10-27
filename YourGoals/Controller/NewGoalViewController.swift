//
//  NewGoalViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

protocol NewGoalViewControllerDelegate {
    func createNewGoal(goalInfo: GoalInfo)
}

class NewGoalViewController: UIViewController {
    @IBOutlet weak var goalNameField: UITextField!
    @IBOutlet weak var reasonField: UITextView!
    @IBOutlet weak var targetDatePicker: UIDatePicker!
    @IBOutlet weak var goalImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    var delegate:NewGoalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonField.layer.cornerRadius = 5
        reasonField.layer.borderColor = UIColor.gray.cgColor
        reasonField.layer.borderWidth = 2.3
        
        // Do any additional setup after loading the view.
        
        configureNewGoal()
        configureImagePicker(imagePicker: self.imagePicker)
    }
    
    func configureNewGoal() {
        self.goalNameField.text = ""
        self.reasonField.text = ""
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
        
        return try GoalInfo(nname: goalName, reason: reason, targetDate: targetDate, image:image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectNewImageAction(_ sender: Any) {
        selectImageFromPicker(imagePicker: self.imagePicker)
    }
    
    @IBAction func saveGoalAction(_ sender: Any) {
        do {
            let goalInfo = try goalInfoFromFields()
            delegate?.createNewGoal(goalInfo: goalInfo)
        }
        catch let error {
            NSLog("could not create a goal info from fields. \(error.localizedDescription)")
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
