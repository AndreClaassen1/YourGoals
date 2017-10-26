//
//  NewGoalCell.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

protocol NewGoalCellDelegate {
    func newGoalClicked()
}

class NewGoalCell: UICollectionViewCell {

    var delegate:NewGoalCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Factory Method
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> NewGoalCell {
        guard let cell: NewGoalCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue NewGoalCell ***")
        }
        return cell
    }
    
    // MARK: - configure
    
    func configure(owner: NewGoalCellDelegate) {
        self.delegate = owner
    }
}
