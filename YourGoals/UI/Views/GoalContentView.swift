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
    
    /// show a goal in the view with a progress indicator of the given date
    ///
    /// - Parameters:
    ///   - goal: a goal
    ///   - date: calculate progress for this date
    ///   - goalIsActive: an indicator, that this goal is active
    ///   - manager: a core data storage managner
    /// - Throws: core data excepiton
    func show(goal: Goal, forDate date: Date, goalIsActive:Bool, manager: GoalsStorageManager) throws {
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
        try progressIndicatorView.setProgress(forGoal: goal, forDate: date,  manager: manager)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reasonLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
    }
    
    // MARK: - Animiation
    
    internal func configureDescriptionItems(shouldBeVisible: Bool) {
        let isHidden = !shouldBeVisible
        self.progressIndicatorView.isHidden = isHidden
        self.titleLabel.isHidden = isHidden
        self.reasonLabel.isHidden = isHidden
        self.overlayView.isHidden = isHidden
    }
 
}
