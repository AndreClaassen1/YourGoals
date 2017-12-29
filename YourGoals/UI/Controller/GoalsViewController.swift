//
//  ViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData

class GoalsViewController: UIViewController, NewGoalCellDelegate, EditGoalFormControllerDelegate, GoalDetailViewControllerDelegate {
    
    // data properties
    var manager:GoalsStorageManager!
    var strategy:Goal!
    var goals:[Goal] = []
    var selectedGoal:Goal?
    
    internal let presentStoryAnimationController = PresentStoryViewAnimationController(origin: .fromLargeCell)
    internal let dismissStoryAnimationController = DismissStoryViewAnimationController(origin: .fromLargeCell)
    
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
        guard let identifier = segue.identifier else {
            assertionFailure("couldn't prepare without an identifier")
            return
        }
        
        switch identifier {
        case "presentShowGoal":
            let detailController = segue.destination as! GoalDetailViewController
            detailController.transitioningDelegate = self
            detailController.goal = self.selectedGoal
            detailController.delegate = self
            
        case "presentEditGoalOld":
            var parameter = segue.destination as! EditGoalSegueParameter
            parameter.delegate = self
            parameter.commit()
            
        case "presentEditGoal":
            var parameter = (segue.destination as! UINavigationController).topViewController as! EditGoalSegueParameter
            parameter.delegate = self
            parameter.commit()
        default:
            assertionFailure("no segue with identifier \(identifier) found")
            
        }
    }
    
    // MARK: - NewGoalCellDelegate
    
    func newGoalClicked() {
        if SettingsUserDefault.standard.newFunctions {
            performSegue(withIdentifier: "presentEditGoal", sender: self)
        }
        else {
            performSegue(withIdentifier: "presentEditGoalOld", sender: self)
        }
    }
    
    // MARK: - EditGoalFormControllerDelegate
    
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


