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
        
        cornerView.layer.cornerRadius = 14.0
        cornerView.clipsToBounds = true
    }

}
