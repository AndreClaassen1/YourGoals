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

enum GoalDetailViewControllerMode {
    case tasksMode
    case habitsMode
}

protocol GoalDetailViewControllerDelegate {
    func goalChanged()
    func commitmentChanged()
}

/// show a goal and all of its tasks in detail
class GoalDetailViewController: UIViewController, EditActionableViewControllerDelegate, EditGoalViewControllerDelegate, ActionableTableViewDelegate {
    
    // container and constraints for animating this view
    @IBOutlet internal weak var contentContainerView: UIView!
    @IBOutlet internal weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet internal weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet internal weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet internal weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet internal var headerHeightConstraint: NSLayoutConstraint!
    
    // view for presenting tasks and habits
    @IBOutlet internal weak var goalContentView: GoalContentView!
    @IBOutlet internal weak var tasksView: ActionableTableView!
    @IBOutlet private weak var toggleHabitsButton: UIButton!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var closerButton: UIButton!
    
    /// Header Image Height
    var goal:Goal!
    var tasksOrdered: [Task]!
    var editActionable:Actionable? = nil
    let manager = GoalsStorageManager.defaultStorageManager
    var delegate:GoalDetailViewControllerDelegate?
    var reorderTableView: LongPressReorderTableView!
    var mode = GoalDetailViewControllerMode.tasksMode
    
    fileprivate func configure(goal:Goal) throws {
        // Do any additional setup after loading the view.
        self.goal = goal
        try self.goalContentView.show(goal: goal, forDate: Date(), goalIsActive: goal.isActive(forDate: Date()), manager: self.manager)
    }
    
    override func viewDidLoad() {
        do {
            super.viewDidLoad()
            try configure(goal: self.goal)
            self.configureTableView(forMode: mode)
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeDown.direction = .down
            self.view.addGestureRecognizer(swipeDown)
            
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    func convertControllerModeToType(mode: GoalDetailViewControllerMode) -> ActionableType {
        switch mode {
        case .habitsMode: return .habit
        case .tasksMode: return .task
        }
    }
    
    func dataSourceForMode(_ mode: GoalDetailViewControllerMode) -> ActionableDataSource {
        let actionableType = convertControllerModeToType(mode: mode)
        return ActionableDataSourceProvider(manager: self.manager).dataSource(forGoal: self.goal, andType: actionableType)
    }
    
    func configureTableView(forMode mode: GoalDetailViewControllerMode) {
        let dataSource = dataSourceForMode(mode)
        self.tasksView.configure(dataSource: dataSource,delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tasksView.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    fileprivate func setEditActionableViewControllerParameter(parameter: EditActionableViewControllerParameter) {
        // make parameter variable
        var parameter = parameter
        
        parameter.goal = self.goal
        parameter.delegate = self
        parameter.editActionable = self.editActionable
        parameter.manager = self.manager
        
        switch mode {
        case .tasksMode:
            parameter.editActionableType = .task
        case .habitsMode:
            parameter.editActionableType = .habit
        }
        
        parameter.commitParameter()
        self.editActionable = nil
    }
    
    /// In a storyboard-based application,
    /// you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            assertionFailure("no identifier set in segue \(segue)")
            return
        }
    
        switch identifier {
        case "presentEditActionable":
            let parameter = (segue.destination as! UINavigationController).topViewController! as! EditActionableViewControllerParameter
            setEditActionableViewControllerParameter(parameter: parameter)
            return
        case "presentEditGoalOld":
            let editGoalController = segue.destination as! EditGoalViewController
            editGoalController.delegate = self
            editGoalController.editGoal = self.goal
            return
        default:
            assertionFailure("couldn't prepare segue with destination: \(segue)")
        }
    }
    
    func refreshView() throws {
        self.tasksView.reload()
        try self.configure(goal: self.goal)
    }
    
    // MARK: - EditActionableViewControllerDelegate
    
    func createNewActionable(actionableInfo: ActionableInfo) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        self.goal = try goalComposer.create(actionableInfo: actionableInfo, toGoal: goal).goal
        try self.refreshView()
    }
    
    func updateActionable(actionable: Actionable, updateInfo: ActionableInfo) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        self.goal = try goalComposer.update(actionable: actionable, withInfo: updateInfo)
        try self.refreshView()
    }
    
    func deleteActionable(actionable: Actionable) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        self.goal = try goalComposer.delete(actionable: actionable)
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
            try configure(goal: goal)
        }
        catch let error {
            self.showNotification(forError: error)
        }
        
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
    func requestForEdit(actionable: Actionable) {
        self.editActionable = actionable
        performSegue(withIdentifier: "presentEditActionable", sender: self)
    }
    
    func goalChanged(goal: Goal) {
        do {
            self.goal = goal
            try self.configure(goal: goal)
            self.delegate?.goalChanged()
            
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
    
    func progressChanged(actionable: Actionable) {
        self.delegate?.goalChanged()
    }
    
    /// toggle between habits and tasks and reload the table view
    @IBAction func toggleHabitsAction(_ sender: Any) {
        if self.mode == .tasksMode {
            self.mode = .habitsMode
        } else {
            self.mode = .tasksMode
        }
        
        configureTableView(forMode: self.mode)
    }
    
    func commitmentChanged() {
        self.delegate?.goalChanged()
    }
    
    // MARK: - UI Events
    
    @IBAction func addNewActionableTouched(_ sender: Any) {
        
        self.editActionable = nil
        performSegue(withIdentifier: "presentEditActionable", sender: self)
    }
    
}
