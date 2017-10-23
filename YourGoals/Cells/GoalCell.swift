//
//  GoalCellCollectionViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 23.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class GoalCell: BaseRoundedCardCell {

    /// Image View
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Factory Method
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> GoalCell {
        guard let cell: GoalCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue GoalCell ***")
        }
        
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 14.0
    }


}
