//
//  PlanningViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 07.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit


/// view controller for planning a week or more
class PlanningViewController: UIViewController, ActionableTableViewDelegate {
    @IBOutlet weak var actionableTableView: ActionableTableView!
    
    /// the storage manager needed for various core data operaitons
    var manager = GoalsStorageManager.defaultStorageManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Planning"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.actionableTableView.configure(manager: self.manager, dataSource: PlannableTasksDataSource(manager: self.manager), delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ActionableTableViewDelegate
    
    func requestForEdit(actionable: Actionable) {
        
    }
    
    func goalChanged(goal: Goal) {
        
    }
    
    func progressChanged(actionable: Actionable) {
        
    }
    
    func commitmentChanged() {
        
    }
}
