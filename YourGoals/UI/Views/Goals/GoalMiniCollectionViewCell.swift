//
//  GoalMiniCollectionViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 09.07.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

let colors = [UIColor.green, UIColor.red, UIColor.blue, UIColor.gray, UIColor.brown ]

class GoalMiniCollectionViewCell: UICollectionViewCell {

    var goalMiniCell:GoalMiniCell!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.goalMiniCell = GoalMiniCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        self.addSubview(goalMiniCell)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> GoalMiniCollectionViewCell {
        guard let cell: GoalMiniCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue GetStartedListCell ***")
        }
        return cell
    }
    
    func show(goal: Goal, forDate date: Date, goalIsActive:Bool, backburned: Bool, manager: GoalsStorageManager) throws {
        try self.goalMiniCell.show(goal: goal, forDate: date, goalIsActive: goalIsActive, backburned: backburned, manager: manager)
    }
}

// MARK: - TransitionAnimationSourceMetrics

extension GoalMiniCollectionViewCell: TransitionAnimationSourceMetrics {
    /// retrieve the metrics of the selected image relative to the given controller view
    ///
    /// - Parameter view: controller view
    /// - Returns: the transition animation metrics
    func animationMetrics(relativeTo controllerView: UIView) -> TransitionAnimationMetrics {
        return self.goalMiniCell.animationMetrics(relativeTo: controllerView)
    }
}

