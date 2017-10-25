//
//  GoalsViewController+CollectionView.swift
//  YourGoals
//
//  Created by André Claaßen on 23.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension GoalsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Configuration
    
    internal func configure(collectionView: UICollectionView) {
        self.manager = GoalsStorageManager.defaultStorageManager
        self.strategy = try! StrategyRetriever(manager: self.manager).activeStrategy()
        collectionView.registerReusableCell(GoalCell.self)
        collectionView.registerReusableCell(GoalCell2.self)
        collectionView.registerSupplementaryView(TodaySectionHeader.self, kind: UICollectionElementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    // MARK: - Goal Handling
    
    func numberOfGoals() -> Int {
        return self.strategy?.subGoals?.count ?? 0
    }

    func goalForIndexPath(path:IndexPath) -> Goal {
        guard let subGoals = self.strategy?.subGoals else {
            assertionFailure("could not extract goals from strategy: \(String(describing: self.strategy))")
            return Goal()
        }
        
        guard let goal = subGoals.allObjects[path.row] as? Goal else {
            assertionFailure("could not extract goal with row \(path.row) from \(subGoals)")
            return Goal()
        }
        
        return goal
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfGoals()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let goalCell = GoalCell2.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
        let goal = self.goalForIndexPath(path: indexPath)
        goalCell.show(goal: goal)
        return goalCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: collectionView.bounds.width, height: BaseRoundedCardCell.cellHeight)
        } else {
            
            // Number of Items per Row
            let numberOfItemsInRow = 2
            
            // Current Row Number
            let rowNumber = indexPath.item/numberOfItemsInRow
            
            // Compressed With
            let compressedWidth = collectionView.bounds.width/3
            
            // Expanded Width
            let expandedWidth = (collectionView.bounds.width/3) * 2
            
            // Is Even Row
            let isEvenRow = rowNumber % 2 == 0
            
            // Is First Item in Row
            let isFirstItem = indexPath.item % numberOfItemsInRow != 0
            
            // Calculate Width
            var width: CGFloat = 0.0
            if isEvenRow {
                width = isFirstItem ? compressedWidth : expandedWidth
            } else {
                width = isFirstItem ? expandedWidth : compressedWidth
            }
            
            return CGSize(width: width, height: BaseRoundedCardCell.cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: TodaySectionHeader.viewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = TodaySectionHeader.dequeue(fromCollectionView: collectionView, ofKind: kind, atIndexPath: indexPath)
        sectionHeader.shouldShowProfileImageView = (indexPath.section == 0)
        return sectionHeader
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            presentStoryAnimationController.selectedCardFrame = cell.frame
            dismissStoryAnimationController.selectedCardFrame = cell.frame
            performSegue(withIdentifier: "presentGoal", sender: self)
        }
    }
}
