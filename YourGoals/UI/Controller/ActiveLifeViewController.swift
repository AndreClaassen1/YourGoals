//
//  ActiveLifeViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 17.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import UIKit

class ActiveLifeViewController: UIViewController, ActionableTableViewDelegate, EditActionableViewControllerDelegate {
    
    @IBOutlet weak var todayTableView: ActionableTableView!
    var manager = GoalsStorageManager.defaultStorageManager
    var editActionable:Actionable? = nil
    var editActionableType:ActionableType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Active Life"
        self.todayTableView.configure(manager: self.manager, dataSource: CommittedTasksDataSource(manager: self.manager), delegate: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            
        default:
            fatalError("couldn't process segue: \(String(describing: segue.identifier))")
        }
    }
    
    
    // MARK: - ActionableTableViewDelegate
    
    func reloadAll() {
        self.todayTableView.reload()
    }
    
    func requestForEdit(actionable: Actionable) {
        self.editActionable = actionable
        self.editActionableType = actionable.type
        perform(segue: StoryboardSegue.Main.presentEditActionable)
        // performSegue(withIdentifier: StoryboardSegue.Main.presentEditActionable.raw, sender: self)
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
        let _ = try goalComposer.update(actionable: actionable, withInfo: updateInfo, forDate: Date())
        self.reloadAll()
    }
    
    func deleteActionable(actionable: Actionable) throws {
        let goalComposer = GoalComposer(manager: self.manager)
        let _ = try goalComposer.delete(actionable: actionable)
        self.reloadAll()
    }
    
}
