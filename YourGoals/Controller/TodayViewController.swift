//
//  TodayViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, TasksViewDelegate, GoalDetailViewControllerDelegate {
    

    @IBOutlet weak var goalsCollectionView: UICollectionView!
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var committedTasksView: TasksView!
    
    var manager = GoalsStorageManager.defaultStorageManager
    var selectedGoal:Goal? = nil
    var strategy:Goal! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Today"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.configure(collectionView: self.goalsCollectionView)
        self.committedTasksView.configure(manager: self.manager, mode: .committedTasks,  forGoal: nil, delegate: self)
        
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
    }
    
    // MARK: - TasksViewDelegate
    
    func requestForEdit(task: Task) {
        performSegue(withIdentifier: "presentEditTask", sender: self)
    }
    
    func goalChanged(goal: Goal) {
        self.reloadCollectionView(collectionView: self.goalsCollectionView)
    }
    
    func goalChanged() {
        self.reloadCollectionView(collectionView: self.goalsCollectionView)
    }
    
    func commitmentChanged() {
        
    }

    // MARK: - GoalDetailViewControllerDelegate

}
