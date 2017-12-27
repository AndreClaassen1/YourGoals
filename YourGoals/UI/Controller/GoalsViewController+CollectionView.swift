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
        collectionView.registerReusableCell(GoalCell2.self)
        collectionView.registerReusableCell(NewGoalCell.self)
        collectionView.registerSupplementaryView(GoalsSectionHeader.self, kind: UICollectionElementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.reloadGoalsCollection()
    }
    
    func reloadGoalsCollection() {
        do {
            self.strategy = try StrategyManager(manager: self.manager).assertValidActiveStrategy()
            self.goals = strategy.allGoalsByPrio()
            self.collectionView.reloadData()
        }
        catch let error {
            showNotification(forError: error)
        }
    }
    
    // MARK: - Goal Handling helper methods
    
    func numberOfGoals() -> Int {
        return self.goals.count
    }
    
    func goalForIndexPath(path:IndexPath) -> Goal {
        return self.goals[path.row]
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfGoals() + 1 // one for the new goal entry
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        do {
            if indexPath.row == numberOfGoals() {
                let newGoalCell = NewGoalCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
                newGoalCell.configure(owner: self)
                return newGoalCell
            } else {
                let date = Date()
                let goalCell = GoalCell2.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
                let goal = self.goalForIndexPath(path: indexPath)
                try goalCell.show(goal: goal, forDate: date, goalIsActive: goal.isActive(forDate: date), manager: self.manager)
                return goalCell
            }
        }
        catch let error {
            self.showNotification(forError: error)
            return UICollectionViewCell()
        }
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
        return CGSize(width: collectionView.bounds.width, height: GoalsSectionHeader.viewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = GoalsSectionHeader.dequeue(fromCollectionView: collectionView, ofKind: kind, atIndexPath: indexPath)
        sectionHeader.shouldShowProfileImageView = (indexPath.section == 0)
        return sectionHeader
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let animationSourceMetrics = collectionView.cellForItem(at: indexPath) as? TransitionAnimationSourceMetrics {
            let metrics = animationSourceMetrics.animationMetrics(relativeTo: self.view)
            
            presentStoryAnimationController.selectedCardMetrics = metrics
            dismissStoryAnimationController.selectedCardMetrics = metrics
        }
        
        self.selectedGoal = goalForIndexPath(path: indexPath)
        performSegue(withIdentifier: "presentEditGoalOld", sender: self)
    }
}
