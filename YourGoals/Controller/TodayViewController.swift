//
//  TodayViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController, TasksViewDelegate, GoalDetailViewControllerDelegate, EditTaskViewControllerDelegate {

    
    @IBOutlet weak var goalsCollectionView: UICollectionView!
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var committedTasksView: TasksView!
    @IBOutlet weak var activeWorkTasksView: TasksView!
    
    var manager = GoalsStorageManager.defaultStorageManager
    var selectedGoal:Goal? = nil
    var strategy:Goal! = nil
    var editTask:Task? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Today"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.configure(collectionView: self.goalsCollectionView)
        self.committedTasksView.configure(manager: self.manager, mode: .committedTasks,  forGoal: nil, delegate: self)
        self.activeWorkTasksView.configure(manager: self.manager, mode: .activeTasks, forGoal: nil, delegate: self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if let editTaskController = segue.destination as? EditTaskViewController {
            editTaskController.goal = self.editTask?.goal
            editTaskController.delegate = self
            editTaskController.editTask = self.editTask
            self.editTask = nil
        }
        
    }
    
    // MARK: - TasksViewDelegate
    
    func reloadAll() {
        self.reloadCollectionView(collectionView: self.goalsCollectionView)
        self.committedTasksView.reload()
        self.activeWorkTasksView.reload()
    }
    
    
    func requestForEdit(task: Task) {
        self.editTask = task
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
    
    func progressChanged(task: Task) {
        self.reloadAll()
    }

    // MARK: - GoalDetailViewControllerDelegate

    func createNewTask(taskInfo: TaskInfo) throws {
        
    }
    
    func updateTask(taskInfo: TaskInfo, withId id: NSManagedObjectID) throws {
        self.reloadAll()
    }
    
    func deleteTask(taskWithId: NSManagedObjectID) throws {
        self.reloadAll()
    }
    
}
