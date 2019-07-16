//
//  ActiveLifeViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 17.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import UIKit

/// this is a view controller for displaying the active life table view. maybe, this will be one day the new today task controller
class ActiveLifeViewController: UIViewController, ActionableTableViewDelegate, EditActionableViewControllerDelegate {
    
    /// the actionable table view for displaying the task sheet
    @IBOutlet weak var activeLifeTableView: ActionableTableView!
    
    /// a core data storeage mangaegr
    var manager = GoalsStorageManager.defaultStorageManager
    
    /// editable variables. I have no clue, to code this better yet
    var editActionable:Actionable? = nil
    var editActionableType:ActionableType? = nil
    
    /// initialitze the table view and the navigation bar
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Active Life"
        self.activeLifeTableView.configure(manager: self.manager, dataSource: ActiveLifeDataSource(manager: self.manager), delegate: self)
    }
    
    // MARK: - Navigation
    
    /// prepare for editing the selected actionable
    ///
    /// - Parameters:
    ///   - segue: the segue
    ///   - sender: the sener
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
        self.activeLifeTableView.reload()
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
    
    func registerCells(inTableView tableView: UITableView) {
        tableView.registerReusableCell(ActiveLifeTableCell.self)
    }
    
    func dequeueActionableCell(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> ActionableCell {
        let cell = ActiveLifeTableCell.dequeue(fromTableView: tableView, atIndexPath: indexPath)
        return cell
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
