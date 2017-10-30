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
    
    func show(goal: Goal, goalIsActive:Bool) {
        goalContentView.show(goal: goal, goalIsActive: goalIsActive)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerView.layer.cornerRadius = 14.0
        cornerView.clipsToBounds = true
    }

}
