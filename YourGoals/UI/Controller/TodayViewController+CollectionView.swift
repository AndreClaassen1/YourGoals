//
//  TodayViewControoller+CollectionView.swift
//  YourGoals
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Configuration
    
    func reloadStrategy() throws {
        let settings = SettingsUserDefault()
        self.strategy = try StrategyManager(manager: self.manager).assertValidActiveStrategy()
        self.goals = self.strategy.allGoalsByPrio(withBackburned: settings.backburnedGoals)
    }
    
    func reloadCollectionView(collectionView: UICollectionView) {
        do {
            try self.reloadStrategy()
            collectionView.reloadData()
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    internal func configure(collectionView: UICollectionView) {
        self.manager = GoalsStorageManager.defaultStorageManager
        try! reloadStrategy()
        collectionView.register(GoalMiniCollectionViewCell.self, forCellWithReuseIdentifier: "GoalMiniCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.allowsSelection = true
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
        return numberOfGoals() // one for the new goal entry
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        do {
            let goalCell = GoalMiniCollectionViewCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
            let goal = self.goalForIndexPath(path: indexPath)
            let date = Date()
            try goalCell.show(goal: goal, forDate: date, goalIsActive: goal.isActive(forDate: date), backburned: goal.backburned,  manager: self.manager)
            return goalCell
        }
        catch let error {
            self.showNotification(forError: error)
            return UICollectionViewCell()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let animationSourceMetrics = collectionView.cellForItem(at: indexPath) as? TransitionAnimationSourceMetrics {
            let metrics = animationSourceMetrics.animationMetrics(relativeTo: self.view)
            
            presentStoryAnimationController.selectedCardMetrics = metrics
            dismissStoryAnimationController.selectedCardMetrics = metrics
        }
        
        self.selectedGoal = goalForIndexPath(path: indexPath)
        performSegue(withIdentifier: "presentShowGoal", sender: self)
    }
}
