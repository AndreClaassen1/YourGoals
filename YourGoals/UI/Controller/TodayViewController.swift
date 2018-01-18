//
//  TodayViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData

/// show the today view screen of the YourGoals App
class TodayViewController: UIViewController, ActionableTableViewDelegate, GoalDetailViewControllerDelegate, EditActionableViewControllerDelegate {
    /// a collaction view for small goals pictures
    @IBOutlet weak var goalsCollectionView: UICollectionView!
    
    // constraints for manipulating the table veiws
    @IBOutlet weak var activeTasksHeight: NSLayoutConstraint!
    var originalTasksHeight:CGFloat = 0.0
    @IBOutlet weak var committedTasksHeight: NSLayoutConstraint!
    @IBOutlet weak var habitsTableHeight: NSLayoutConstraint!
    /// a table view with habits
    @IBOutlet weak var habitsTableView: ActionableTableView!
    
    /// a table view with comitted tasks to do
    @IBOutlet weak var committedTasksView: ActionableTableView!
    
    /// a taask view with the active task
    @IBOutlet weak var activeWorkTasksView: ActionableTableView!
    
    @IBOutlet weak var workloadView: WorkloadView!
    /// the storage manager needed for various core data operaitons
    var manager = GoalsStorageManager.defaultStorageManager
    var selectedGoal:Goal? = nil
    var goals:[Goal] = []
    var strategy:Goal! = nil
    var editActionable:Actionable? = nil
    var editActionableType:ActionableType? = nil
    
    internal let presentStoryAnimationController = PresentStoryViewAnimationController(origin: .fromMiniCell)
    internal let dismissStoryAnimationController = DismissStoryViewAnimationController(origin: .fromMiniCell)
    
    override func viewDidLoad() {
        do {
            super.viewDidLoad()
            self.originalTasksHeight = activeTasksHeight.constant
            self.navigationController?.navigationBar.topItem?.title = "Today"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            
            self.configure(collectionView: self.goalsCollectionView)
            self.committedTasksView.configure(manager: self.manager, dataSource: CommittedTasksDataSource(manager: self.manager, mode: .activeTasksNotIncluded), delegate: self,
                                              calculatestartingTimes: true,
                                              varyingHeightConstraint: self.committedTasksHeight)
            self.activeWorkTasksView.configure(manager: self.manager, dataSource: ActiveTasksDataSource(manager: self.manager), delegate: self,
                                               calculatestartingTimes: true)
            self.habitsTableView.configure(manager: self.manager, dataSource: HabitsDataSource(manager: self.manager), delegate: self, varyingHeightConstraint: self.habitsTableHeight)
            try self.workloadView.configure(manager: self.manager, forDate: Date())
            
            // Do any additional setup after loading the view.
            self.reloadAll()
        }
        catch let error{
            self.showNotification(forError: error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadAll()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        guard let identifier = segue.identifier else {
            fatalError("couldn't process segue with no identifier")
        }
        
        switch identifier {
        case "presentEditActionable":
            var parameter = (segue.destination as! UINavigationController).topViewController! as! EditActionableViewControllerParameter
            
            parameter.goal = self.editActionable?.goal
            parameter.delegate = self
            parameter.editActionable = self.editActionable
            parameter.editActionableType = self.editActionableType
            parameter.manager = self.manager
            parameter.commitParameter()
            self.editActionable = nil
            self.editActionableType = nil
            
        case "presentShowGoal":
            guard let detailController = destinationViewController as? GoalDetailViewController else {
                fatalError("couldn't extract goal view controller for segue presentEditGoalOld")
            }
            detailController.transitioningDelegate = self
            detailController.goal = self.selectedGoal
            detailController.delegate = self
            
        default:
            fatalError("couldn't process segue: \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - ActionableTableViewDelegate
    
    /// reload all data for the today view
    /// hide the active task pane, if there are no active tasks which aren't committed
    func reloadAll() {
        do {
            let startingTime = Date()
            
            self.reloadCollectionView(collectionView: self.goalsCollectionView)
            self.committedTasksView.reload()
            self.habitsTableView.reload()
            //            let showActivWorkTasksView = try TasksRequester(manager: self.manager).areThereActiveTasksWhichAreNotCommitted(forDate:
            let showActivWorkTasksView = try TasksRequester(manager: self.manager).areThereActiveTasks(forDate: startingTime)

            if showActivWorkTasksView {
                // self.activeTasksHeight.constant = originalTasksHeight
                self.activeTasksHeight.constant = 215.0
                self.activeWorkTasksView.isHidden = false
                self.activeWorkTasksView.reload()
            } else {
                self.activeTasksHeight.constant = 0.0
            }
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    func requestForEdit(actionable: Actionable) {
        self.editActionable = actionable
        self.editActionableType = actionable.type
        performSegue(withIdentifier: "presentEditActionable", sender: self)
    }
    
    func goalChanged(goal: Goal) {
        self.reloadAll()
    }
    
    func goalChanged() {
        self.reloadAll()
    }
    
    func commitmentChanged() {
        self.reloadAll()
    }
    
    func progressChanged(actionable: Actionable) {
        self.reloadAll()
    }
    
    // MARK: - GoalDetailViewControllerDelegate
    
    func createNewActionable(actionableInfo: ActionableInfo) throws {
        
    }
    
    func updateActionable(actionable: Actionable, updateInfo: ActionableInfo) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        let _ = try goalComposer.update(actionable: actionable, withInfo: updateInfo)
        self.reloadAll()
    }
    
    func deleteActionable(actionable: Actionable) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        let _ = try goalComposer.delete(actionable: actionable)
        self.reloadAll()
    }
}


