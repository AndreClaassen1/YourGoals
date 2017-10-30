//
//  GoalContentView.swift
//  YourGoals
//
//  Created by André Claaßen on 30.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class GoalContentView: NibLoadingView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressIndicatorView: ProgressIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var goalIsActive = false
    
    // MARK: - Factory Method
    
    
    // MARK: - Content
    
    func showActiveGoalState(_ goalIsActive:Bool) {
        if goalIsActive {
            self.overlayView.backgroundColor = UIColor.green.withAlphaComponent(0.9)
        } else {
            self.overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        }
    }
    
    func show(goal: Goal, goalIsActive:Bool) {
        guard let data = goal.imageData?.data else {
            fatalError ("could not extract data: \(String(describing: goal.imageData))")
        }
        
        guard let image = UIImage(data: data) else {
            fatalError ("could not create Image from data: \(data)")
        }
        
        showActiveGoalState(goalIsActive)
        self.goalIsActive = goalIsActive
        imageView.image = image
        reasonLabel.text = goal.reason
        reasonLabel.sizeToFit()
        titleLabel.text = goal.name
        titleLabel.sizeToFit()
        progressIndicatorView.setProgress(forGoal: goal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reasonLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
    }
    
}
