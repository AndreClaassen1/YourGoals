//
//  ProtocolSectionView.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

class ProtocolSectionView: UITableViewHeaderFooterView {

    @IBOutlet weak var goalMiniCell: GoalMiniCell!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalExplanationLabel: UILabel!
    @IBOutlet weak var goalWorkedTimeLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// configure this view with values
    func configure(manager: GoalsStorageManager, goalInfo: ProtocolGoalInfo, workedOnGoal:TimeInterval) throws {
        
        try self.goalMiniCell.show(goal: goalInfo.goal, forDate: goalInfo.date, goalIsActive: false, backburned: false, manager: manager)
        
        dateLabel.text = goalInfo.date.formattedInLocaleFormat()
        goalExplanationLabel.text = goalInfo.goal.reason
        goalWorkedTimeLabel.text = "Sie haben \(workedOnGoal.formattedAsString()) gearbeitet."
    }

}
