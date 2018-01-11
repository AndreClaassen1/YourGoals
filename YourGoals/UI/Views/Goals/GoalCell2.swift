//
//  WorldPremiereCell.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/17/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import CoreMotion

internal class GoalCell2: BaseRoundedCardCell {
    
    /// Corner View
    @IBOutlet private weak var cornerView: UIView!
    @IBOutlet weak var goalContentView: GoalContentView!
    
    var goalIsActive = false
    let cornerRadius:CGFloat = 14.0
    
    
    // MARK: - Factory Method
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> GoalCell2 {
        guard let cell: GoalCell2 = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue GetStartedListCell ***")
        }
        return cell
    }
    
    // MARK: - Content
    
    /// show a goal in the mini ui collection view cell
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - date: show the progress for this date
    ///   - goalIsActive: true, if goal is active
    ///   - manager: a core data storage manager
    /// - Throws: a core data exception
    func show(goal: Goal, forDate date: Date, goalIsActive:Bool, manager: GoalsStorageManager) throws {
        try goalContentView.show(goal: goal, forDate: date, goalIsActive: goalIsActive, manager: manager)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerView.layer.cornerRadius = cornerRadius
        cornerView.clipsToBounds = true
    }
}

// MARK: - TransitionAnimationSourceMetrics

extension GoalCell2: TransitionAnimationSourceMetrics {
    /// retrieve the metrics of the selected image relative to the given controller view
    ///
    /// - Parameter view: controller view
    /// - Returns: the transition animation metrics
    func animationMetrics(relativeTo view: UIView) -> TransitionAnimationMetrics {
        let frame = self.goalContentView.convert(self.goalContentView.imageView.frame, to: view)
        let metrics = TransitionAnimationMetrics(selectedFrame: frame, cornerRadius: self.cornerRadius)
        return metrics
    }
}
