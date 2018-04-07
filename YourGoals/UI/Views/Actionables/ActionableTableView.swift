//
//  UITasksView.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import LongPressReorder
import MGSwipeTableCell

protocol ActionableTableViewDelegate {
    func requestForEdit(actionable: Actionable)
    func showNotification(forError error: Error)
    func goalChanged(goal: Goal)
    func progressChanged(actionable: Actionable)
    func commitmentChanged()
}

/// a specialized UITableView for displaying tasks
class ActionableTableView: UIView, UITableViewDataSource, UITableViewDelegate, ActionableTableCellDelegate, LongPressReorder {
    var tasksTableView:UITableView!
    var reorderTableView: LongPressReorderTableView!
    var actionables = [Actionable]()
    var startingTimes:[Date]?
    var timer = Timer()
    var timerPaused = false
    var editTask:Task? = nil
    var delegate:ActionableTableViewDelegate!
    var dataSource:ActionableDataSource?
    var constraint:NSLayoutConstraint? = nil
    var constraintOffset:CGFloat = 0
    var panGestureRecognizer:UIPanGestureRecognizer!
    var manager: GoalsStorageManager!
    var calculatestartingTimes = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func commonSetup() {
        self.backgroundColor = UIColor.clear
        self.tasksTableView = UITableView(frame: self.bounds)
        self.configureTaskTableView(self.tasksTableView)
        self.reorderTableView = LongPressReorderTableView(self.tasksTableView, selectedRowScale: .big)
        self.reorderTableView.delegate = self
        self.reorderTableView.enableLongPressReorder()
        self.addSubview(self.tasksTableView)
        self.reorderTableView.delegate = self
        self.scheduleTimerWithTimeInterval(tableView: self.tasksTableView)
    }
    
    /// configure the actionable task view with a data source for actionabels and a delegate for actions
    ///
    /// - Parameters:
    ///   - dataSource: a actionable data source
    ///   - delegate: a delegate for actions like editing or so.
    ///   - varyingHeightConstraint: an optional constraint, if the actionable table view should modify the constriaitn
    func configure(manager: GoalsStorageManager, dataSource: ActionableDataSource, delegate: ActionableTableViewDelegate, calculatestartingTimes:Bool = false, varyingHeightConstraint: NSLayoutConstraint? = nil) {
        self.manager = manager
        self.dataSource = dataSource
        self.calculatestartingTimes = calculatestartingTimes
        self.delegate = delegate
        if let constraint = varyingHeightConstraint {
            self.configure(constraint: constraint)
        }
        
        reload()
    }
    
    /// reload the tasks table view
    func reload() {
        do {
            guard let dataSource = self.dataSource else {
                assertionFailure("you need to configure the ActionableTableView with a datasource first")
                return
            }
            
            
            self.actionables = try dataSource.fetchActionables(forDate: Date(), andSection: nil)
            if calculatestartingTimes {
                self.startingTimes = try TodayScheduleCalculator(manager: self.manager).calculateStartingTimes(forTime: Date(), actionables: self.actionables)
            } else {
                self.startingTimes = nil
            }
            self.tasksTableView.reloadData()
        }
        catch let error {
            self.delegate.showNotification(forError: error)
        }
    }

    /// timer for updating the remaining time for a task
    ///
    /// - Parameter tableView: the table vie
    func scheduleTimerWithTimeInterval(tableView: UITableView) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTaskInProgess), userInfo: tableView, repeats: true)
        timerPaused = false
    }
    
    /// show actual timer in active tasks
    ///
    /// - Parameter timer: timer
    @objc func updateTaskInProgess(timer:Timer) {
        guard !self.timerPaused else {
            return
        }
        
        self.reload()
        
        
//        guard let tableView = timer.userInfo as? UITableView else {
//            assertionFailure("couldn't extract tableView from userInfo")
//            return
//        }
//
//        let paths = indexPathsInProgress()
//        if paths.count > 0 {
//            tableView.beginUpdates()
//            tableView.reloadRows(at: paths, with: UITableViewRowAnimation.none)
//            tableView.endUpdates()
//        }
    }
    
    func reloadTableView() {
        self.tasksTableView.reloadData()
    }
    
    // MARK: - Data Source Helper Methods
    
    func numberOfActionables() -> Int {
        return self.actionables.count
    }
    
    func actionableForIndexPath(path: IndexPath) -> Actionable {
        return self.actionables[path.row]
    }
    
    func estimatedStartingTime(forPath path: IndexPath) -> Date? {
        guard let startingTimes = self.startingTimes else {
            return nil
        }
        
        return startingTimes[path.row]
    }
    
    func updateTaskOrder(initialIndex: IndexPath, finalIndex: IndexPath) throws {
        guard initialIndex != finalIndex else {
            NSLog("no update of order neccessary")
            return
        }
        
        guard let dataSource = self.dataSource else {
            assertionFailure("you need to configure the datasource first")
            return
        }
        
        
        guard let positioning = dataSource.positioningProtocol() else {
            NSLog("no repositioning protocol found")
            return
        }
        
        try positioning.updatePosition(actionables: self.actionables, fromPosition: initialIndex.row, toPosition: finalIndex.row)
        
        reload()
    }
    
    /// retrieve the index path of all task cells, which are in progess
    ///
    /// - Returns: array of index paths
    func indexPathsInProgress() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let date = Date()
        
        for tuple in self.actionables.enumerated() {
            let actionable = tuple.element
            if actionable.isProgressing(atDate: date) {
                indexPaths.append(IndexPath(row: tuple.offset, section: 0))
            }
        }
        
        return indexPaths
    }
    
       
    // MARK: - ActionableTableCellDelegate
    
    func actionableStateChangeDesired(actionable: Actionable) {
        do {
            try switchBehavior(actionable: actionable, date: Date(), behavior: .state)
        }
        catch let error {
            delegate.showNotification(forError: error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.requestForEdit(actionable: self.actionableForIndexPath(path: indexPath))
    }
    
    // MARK: - Reorder handling
    
    func startReorderingRow(atIndex indexPath: IndexPath) -> Bool {
        self.timerPaused = true
        return true
    }
    
    func reorderFinished(initialIndex: IndexPath, finalIndex: IndexPath) {
        do {
            NSLog("reorder finished: init:\(initialIndex) final:\(finalIndex)")
            try updateTaskOrder(initialIndex: initialIndex, finalIndex: finalIndex)
            NSLog("core data store updateted")
            self.timerPaused = false
        }
        catch let error {
            self.delegate?.showNotification(forError: error)
        }
    }
    
    func positionChanged(currentIndex: IndexPath, newIndex: IndexPath) {
        
    }
    
    func allowChangingRow(atIndex indexPath: IndexPath) -> Bool {
        return true
    }
}
