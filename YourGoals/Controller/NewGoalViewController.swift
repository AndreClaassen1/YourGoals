//
//  NewGoalViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController {
    @IBOutlet weak var goalNameField: UITextField!
    @IBOutlet weak var reasonField: UITextView!
    @IBOutlet weak var targetDatePicker: UIDatePicker!
    @IBOutlet weak var goalImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
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
        self.targetDatePicker = Date().addDaysToDate(30)
    }

    func createGoalFromFields() throws -> GoalInfo
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func selectNewImageAction(_ sender: Any) {
        selectImageFromPicker()
    }
    
    @IBAction func saveGoalAction(_ sender: Any) {
        let goal = createGoalFromFields()
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
