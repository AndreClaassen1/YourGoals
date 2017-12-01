//
//  TransitionAnimationOrigin.swift
//  YourGoals
//
//  Created by André Claaßen on 28.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

enum TransitionAnimationOrigin {
    case fromLargeCell
    case fromMiniCell
}

protocol TransitionAnimationSourceMetrics {
    func animationMetrics(relativeTo view: UIView) -> TransitionAnimationMetrics
}

struct TransitionAnimationConstraints {
    
    static let zero = TransitionAnimationConstraints(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0)
    
    let left: CGFloat
    let right: CGFloat
    let top: CGFloat
    let bottom: CGFloat
}

struct TransitionAnimationMetrics {
    let selectedFrame:CGRect
    let cornerRadius:CGFloat
    
    /// calculate of the selected frame (from the UIViewCell) the
    /// starting / ending animation frame for the constraints in the
    /// GoalDetailViewController.view
    ///
    /// - Parameter containerFrame: frame of the container of the transition animation
    /// - Returns: the values for the constraints
    func calculateOriginConstraints(containerFrame:CGRect) -> TransitionAnimationConstraints {
        let left = self.selectedFrame.origin.x
        let right = containerFrame.width - (self.selectedFrame.origin.x + self.selectedFrame.width)
        let top = self.selectedFrame.origin.y - 15.0
        let bottom = -self.selectedFrame.origin.y
        
        return TransitionAnimationConstraints(left: left, right: right, top: top, bottom: bottom)
    }
}
