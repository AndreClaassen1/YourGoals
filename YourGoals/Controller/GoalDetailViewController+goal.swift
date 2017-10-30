//
//  GoalDetailViewController+goal.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit


extension GoalDetailViewController {
    
    /// configure the goal view in this controller
    func configure(goal: Goal) {
        self.goalContentView.show(goal: goal, goalIsActive: goal.isActive(forDate: Date()))
    }

}
