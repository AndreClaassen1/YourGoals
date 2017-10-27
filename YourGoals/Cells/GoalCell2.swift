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
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var goalLabel: UILabel!
    /// Image View
    @IBOutlet private weak var imageView: UIImageView!
    
    /// Overlay View
    @IBOutlet private weak var overlayView: UIView!
    
    /// Corner View
    @IBOutlet private weak var cornerView: UIView!
    
    @IBOutlet weak var progressIndicatorView: ProgressIndicatorView!
    
    // MARK: - Factory Method
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> GoalCell2 {
        guard let cell: GoalCell2 = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue GetStartedListCell ***")
        }
        return cell
    }
    
    // MARK: - Content
    
    func show(goal: Goal) {
        guard let data = goal.imageData?.data else {
            fatalError ("could not extract data: \(String(describing: goal.imageData))")
        }
        
        guard let image = UIImage(data: data) else {
            fatalError ("could not create Image from data: \(data)")
        }
        
        imageView.image = image
        reasonLabel.text = goal.reason
        reasonLabel.sizeToFit()
        goalLabel.text = goal.name
        goalLabel.sizeToFit()
        progressIndicatorView.setProgress(forGoal: goal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerView.layer.cornerRadius = 14.0
        cornerView.clipsToBounds = true
        
        reasonLabel.numberOfLines = 0
        goalLabel.numberOfLines = 0
    }

}
