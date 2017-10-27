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
        headerLabel.text = goal.name
        headerLabel.sizeToFit()
        reasonLabel.text = goal.reason
        reasonLabel.sizeToFit()
        
        if let data = goal.imageData?.data {
            headerImageView.image = UIImage(data: data)
        } else {
            headerImageView.image = nil
        }
        
        progressIndicatorView.setProgress(forGoal: goal)
    }
    
}
