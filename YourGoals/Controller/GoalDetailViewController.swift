//
//  GoalDetailViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 24.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData
import LongPressReorder

protocol GoalDetailViewControllerDelegate {
    func goalChanged()
    func commitmentChanged()
}

/// show a goal and all of its tasks in detail
class GoalDetailViewController: UIViewController, EditTaskViewControllerDelegate, EditGoalViewControllerDelegate, TasksViewDelegate {

    
    @IBOutlet weak var tasksView: TasksView!
    /// Container
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint!
 
    @IBOutlet weak var goalContentView: GoalContentView!
    
    
    /// Header Image Height
    
    var goal:Goal!
    var tasksOrdered: [Task]!
    var timer = Timer()
    var timerPaused = false
    var editTask:Task? = nil
    let manager = GoalsStorageManager.defaultStorageManager
    var delegate:GoalDetailViewControllerDelegate?
    var reorderTableView: LongPressReorderTableView!
    
    fileprivate func configure(goal:Goal) {
        // Do any additional setup after loading the view.
        self.goal = goal
        self.goalContentView.show(goal: goal, goalIsActive: goal.isActive(forDate: Date()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(goal: self.goal)
        self.tasksView.configure(manager: self.manager, mode: .tasksForGoal, forGoal: self.goal, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tasksView.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func positionContainer(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        containerLeadingConstraint.constant = left
        containerTrailingConstraint.constant = right
        containerTopConstraint.constant = top
        containerBottomConstraint.constant = bottom
        view.layoutIfNeeded()
    }
    
//    internal func setHeaderHeight(_ height: CGFloat) {
//        headerImageHeightConstraint.constant = height
//        view.layoutIfNeeded()
//    }
//
//    internal func configureRoundedCorners(shouldRound: Bool) {
//        headerImageView.layer.cornerRadius = shouldRound ? 14.0 : 0.0
//    }
//
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editTaskController = segue.destination as? EditTaskViewController {
            editTaskController.goal = self.goal
            editTaskController.delegate = self
            editTaskController.editTask = self.editTask
            self.editTask = nil
        }
        
        if let editGoalController = segue.destination as? EditGoalViewController {
            editGoalController.delegate = self
            editGoalController.editGoal = goal
        }
        
    }
    
    func refreshView() throws {
        self.tasksView.reload()
        self.configure(goal: self.goal)
    }
    
    // MARK: - EditTaskViewControllerDelegate
    
    func createNewTask(taskInfo: TaskInfo) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        self.goal = try goalComposer.add(taskInfo: taskInfo, toGoal: goal)
        try self.refreshView()
    }
    
    func updateTask(taskInfo: TaskInfo, withId id: NSManagedObjectID) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        self.goal = try goalComposer.update(taskInfo: taskInfo, withId: id, toGoal: goal)
        try self.refreshView()
    }
    
    func deleteTask(taskWithId id: NSManagedObjectID) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        self.goal = try goalComposer.delete(taskWithId: id, fromGoal: self.goal)
        try self.refreshView()
    }
    
    // MARK: - EditGoalViewControllerDelegate
    
    func createNewGoal(goalInfo: GoalInfo) {
        assertionFailure("this function")
    }
    
    func update(goal: Goal, withGoalInfo goalInfo: GoalInfo) {
        do {
            let goalUpdater = GoalUpdater(manager: self.manager)
            try goalUpdater.update(goal: goal, withGoalInfo: goalInfo)
            self.delegate?.goalChanged()
        }
        catch let error {
            self.showNotification(forError: error)
        }
        
        configure(goal: goal)
    }
    
    func delete(goal: Goal) {
        do {
            let goalDeleter = GoalDeleter(manager: self.manager)
            try goalDeleter.delete(goal: goal)
            self.delegate?.goalChanged()
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - tasks view delegate
    
    /// request for editing a task
    ///
    /// - Parameter task: the task
    func requestForEdit(task: Task) {
        self.editTask = task
        performSegue(withIdentifier: "presentEditTask", sender: self)
    }
    
    func goalChanged(goal: Goal) {
        self.goal = goal
        self.configure(goal: goal)
        self.delegate?.goalChanged()
    }
    
    func commitmentChanged() {
        
    }

}
