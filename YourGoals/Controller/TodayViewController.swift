//
//  TodayViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, TasksViewDelegate {
    

    @IBOutlet weak var goalsCollectionView: UICollectionView!
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var committedTasksView: TasksView!
    
    var manager = GoalsStorageManager.defaultStorageManager
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Today"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        committedTasksView.configure(manager: self.manager, mode: .committedTasks,  forGoal: nil, delegate: self)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: TasksViewDelegate
    
    func requestForEdit(task: Task) {
        
    }
    
    func goalChanged(goal: Goal) {
        
    }
    
    func commitmentChanged() {
        
    }

}
