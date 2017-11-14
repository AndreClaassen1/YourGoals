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
    
    /// the storage manager needed for various core data operaitons
    var manager = GoalsStorageManager.defaultStorageManager
    var selectedGoal:Goal? = nil
    var strategy:Goal! = nil
    var editActionable:Actionable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalTasksHeight = activeTasksHeight.constant
        self.navigationController?.navigationBar.topItem?.title = "Today"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.configure(collectionView: self.goalsCollectionView)
        self.committedTasksView.configure(dataSource: CommittedTasksDataSource(manager: self.manager), delegate: self)
        self.activeWorkTasksView.configure(dataSource: ActiveTasksDataSource(manager: self.manager), delegate: self)
        self.habitsTableView.configure(dataSource: HabitsDataSource(manager: self.manager), delegate: self)
        
        // Do any additional setup after loading the view.
        self.reloadAll()
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
        self.committedTasksView.reload()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let detailController = destinationViewController as? GoalDetailViewController {
            detailController.goal = self.selectedGoal
            detailController.delegate = self
            return
        }
        
        if let editTaskController = segue.destination as? EditActionableViewController {
            editTaskController.goal = self.editActionable?.goal
            editTaskController.delegate = self
            editTaskController.editActionable = self.editActionable
            self.editActionable = nil
        }
        
    }
    
    // MARK: - ActionableTableViewDelegate
    
    /// reload all data for the today view
    /// hide the active task pane, if there are no active tasks which aren't committed
    func reloadAll() {
        do {
            self.reloadCollectionView(collectionView: self.goalsCollectionView)
            self.committedTasksView.reload()
            let showActivWorkTasksView = try TasksRequester(manager: self.manager).areThereActiveTasksWhichAreNotCommitted(forDate: Date())
            
            if showActivWorkTasksView {
                self.activeTasksHeight.constant = originalTasksHeight
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
        performSegue(withIdentifier: "presentEditTask", sender: self)
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
        // :todo: update code
        self.reloadAll()
    }
    
    func deleteActionable(actionable: Actionable) throws {
        // :todo: delete code
        self.reloadAll()
    }
}
