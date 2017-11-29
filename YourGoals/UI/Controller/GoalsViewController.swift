//
//  ViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData

class GoalsViewController: UIViewController, NewGoalCellDelegate, EditGoalViewControllerDelegate, GoalDetailViewControllerDelegate {
    
    // data properties
    var manager:GoalsStorageManager!
    var strategy:Goal!
    var goals:[Goal] = []
    var selectedGoal:Goal?
    
    internal let presentStoryAnimationController = PresentStoryViewAnimationController(origin: .fromLargeCell)
    internal let dismissStoryAnimationController = DismissStoryViewAnimationController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.manager = GoalsStorageManager.defaultStorageManager
        configure(collectionView: collectionView)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let detailController = destinationViewController as? GoalDetailViewController {
            destinationViewController.transitioningDelegate = self
            detailController.goal = self.selectedGoal
            detailController.delegate = self
            return
        }
        
        if let newGoalController = destinationViewController as? EditGoalViewController {
            newGoalController.delegate = self
            return
        }
    }
    
    // MARK: - NewGoalCellDelegate
    
    func newGoalClicked() {
        performSegue(withIdentifier: "presentEditGoal", sender: self)
    }
    
    // MARK: - EditGoalViewControllerDelegate
    
    func createNewGoal(goalInfo: GoalInfo) {
        do {
            let strategyManager = StrategyManager(manager: self.manager)
            let _ = try strategyManager.createNewGoalForStrategy(goalInfo: goalInfo)
            self.collectionView.reloadData()
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    func update(goal: Goal, withGoalInfo goalInfo: GoalInfo) {
        assertionFailure("this method shouldn't be called")
    }
    
    func delete(goal: Goal) {
        assertionFailure("this method shouldn't be called")
    }
    
    func dismissController() {
        assertionFailure("this method shouldn't be called")
    }
    
    // MARK: - GoalDetailViewControllerDelegate
    
    func goalChanged() {
        self.reloadGoalsCollection()
    }
    
    func commitmentChanged() {
        
    }
}


