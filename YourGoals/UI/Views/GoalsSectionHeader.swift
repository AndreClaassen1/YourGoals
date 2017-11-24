//
//  GoalsSectionHeader.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/17/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

class GoalsSectionHeader: UICollectionReusableView {
    
    internal static let viewHeight: CGFloat = 81

    @IBOutlet private weak var profileImageView: UIImageView!
    
    internal var shouldShowProfileImageView: Bool = true {
        didSet {
            profileImageView.isHidden = !shouldShowProfileImageView
        }
    }
    
    // MARK: - Factory Method
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, ofKind kind: String, atIndexPath indexPath: IndexPath) -> GoalsSectionHeader {
        guard let view: GoalsSectionHeader = collectionView.dequeueSupplementaryView(kind: kind, indexPath: indexPath) else {
            fatalError("*** Failed to dequeue GoalsSectionHeader ***")
        }
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
        profileImageView.layer.borderWidth = 0.5
        profileImageView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
    }
    
}
