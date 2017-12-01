//
//  GoalDetailsViewController+Animation.swift
//  YourGoals
//
//  Created by André Claaßen on 29.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

// MARK: - GoalDetailAnimationBehaviour

protocol GoalDetailAnimationBehavior {
    var view:UIView! {
        get
    }

    func positionContainer(constraints: TransitionAnimationConstraints)
    func configureRoundedCorners(radius: CGFloat)
    func configureDescriptionItems(shouldBeVisible: Bool)
    func setHeaderHeight(_ height: CGFloat)
    func setTaskViewAlpha(_ alpha:CGFloat)
}

extension GoalDetailViewController: GoalDetailAnimationBehavior {
    
    /// animaition helper function to positoin the container at the start and
    /// and of the anmiaiton
    ///
    /// - Parameters:
    ///   - left: value for the leading container constraing
    ///   - right: value for the trailing container constraint
    ///   - top: value for the top constraint
    ///   - bottom: value for the bottom constraint
    internal func positionContainer(constraints: TransitionAnimationConstraints) {
        containerLeadingConstraint.constant = constraints.left
        containerTrailingConstraint.constant = constraints.right
        containerTopConstraint.constant = constraints.top
        containerBottomConstraint.constant = constraints.bottom
        view.layoutIfNeeded()
    }
    
    /// helper function for the presentStoryViewAnimationController
    ///
    /// - Parameter shouldRound: true for round corners
    internal func configureRoundedCorners(radius: CGFloat) {
        self.goalContentView.layer.cornerRadius = radius
        self.view.layoutIfNeeded()
    }
    
    internal func configureDescriptionItems(shouldBeVisible: Bool) {
        self.goalContentView.configureDescriptionItems(shouldBeVisible: shouldBeVisible)
        let isHidden = !shouldBeVisible
        self.closerButton.isHidden = isHidden
    }
    
    /// set the height of the detail view
    ///
    /// - Parameter height: height in pixel
    internal func setHeaderHeight(_ height: CGFloat) {
        self.headerHeightConstraint.constant = height
        self.view.layoutIfNeeded()
    }
    
    internal func setTaskViewAlpha(_ alpha:CGFloat) {
        self.tasksView.alpha = alpha
        self.buttonView.alpha = alpha
    }
}
