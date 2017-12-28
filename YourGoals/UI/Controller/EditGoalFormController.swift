//
//  EditGoalFormController.swift
//  YourGoals
//
//  Created by André Claaßen on 27.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

class EditGoalFormController:FormViewController, EditGoalSegueParameter {
    var delegate: EditGoalViewControllerDelegate!
    var boolCommitted = false
    var editGoal: Goal?
    
    func commit() {
        boolCommitted = true
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Mark: - Eureka Callback function
    
    func deleteClicked() {
        
    }
    
}
