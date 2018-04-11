//
//  PlanningViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 07.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit


/// view controller for planning a week or more
class PlanningViewController: UIViewController, ActionableTableViewDelegate, EditActionableViewControllerDelegate {
  
    
    @IBOutlet weak var actionableTableView: ActionableTableView!
    
    /// the storage manager needed for various core data operaitons
    var manager = GoalsStorageManager.defaultStorageManager
    var editActionable:Actionable?
    
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
    
    func reloadAll() {
        self.actionableTableView.reload()
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
            parameter.editActionableType = .task
            parameter.manager = self.manager
            parameter.commitParameter()
            self.editActionable = nil

            
        default:
            fatalError("couldn't process segue: \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - ActionableTableViewDelegate
    
    func requestForEdit(actionable: Actionable) {
        self.editActionable = actionable
        performSegue(withIdentifier: "presentEditActionable", sender: self)
    }
    
    func progressChanged(actionable: Actionable) {
        self.reloadAll()
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
    
    // MARK: EditActionableViewControllerDelegate
    
    
    
    // MARK: - GoalDetailViewControllerDelegate
    
    func createNewActionable(actionableInfo: ActionableInfo) throws {
        
    }
    
    func updateActionable(actionable: Actionable, updateInfo: ActionableInfo) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        let _ = try goalComposer.update(actionable: actionable, withInfo: updateInfo, forDate: Date())
        self.reloadAll()
    }
    
    func deleteActionable(actionable: Actionable) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        let _ = try goalComposer.delete(actionable: actionable)
        self.reloadAll()
    }
}
