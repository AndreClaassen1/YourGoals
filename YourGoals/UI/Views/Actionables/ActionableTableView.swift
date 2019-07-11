//
//  UITasksView.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol ActionableTableViewDelegate {
    func requestForEdit(actionable: Actionable)
    func showNotification(forError error: Error)
    func goalChanged(goal: Goal)
    func progressChanged(actionable: Actionable)
    func commitmentChanged()
}

/// a specialized UITableView for displaying tasks
class ActionableTableView: UIView, UITableViewDataSource, UITableViewDelegate, ActionableTableCellDelegate {
    var tasksTableView:UITableView!
    var reorderTableView: LongPressReorderTableView!
    var sections = [ActionableSection]()
    var items = [[ActionableItem]]()
    var startingTimes:[[ActionableTimeInfo]]?
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
    var reorderInfo:ReorderInfo?
    
    
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
       
            // load sections and items
            let backburnedGoals = SettingsUserDefault.standard.backburnedGoals
            let date = Date()
            self.sections = try dataSource.fetchSections(forDate: date, withBackburned: backburnedGoals)
            self.items.removeAll()
            if self.sections.count == 0 {
                self.items.append(try dataSource.fetchItems(forDate: date, withBackburned: backburnedGoals, andSection: nil))
            } else {
                for section in sections {
                    self.items.append(try dataSource.fetchItems(forDate: date, withBackburned: backburnedGoals, andSection: section))
                }
            }
            
            // calculate starting times
            self.startingTimes = nil
            if calculatestartingTimes {
                let scheduleCalculator = TodayScheduleCalculator(manager: self.manager)
                self.startingTimes = [[ActionableTimeInfo]]()
                if self.sections.count == 0 {
                    let actionables = self.items[0].map { $0.actionable }
                    self.startingTimes = [try scheduleCalculator.calculateTimeInfos(forTime: date, actionables: actionables)]
                } else {
                    for tuple in self.sections.enumerated()  {
                        let actionables = self.items[tuple.offset].map { $0.actionable }
                        if let startingTimeForSection = tuple.element.calculateStartingTime(forDate: date) {
                            self.startingTimes?.append(try scheduleCalculator.calculateTimeInfos(forTime: startingTimeForSection, actionables: actionables))
                        }
                        else {
                            self.startingTimes?.append([])
                        }
                    }
                }
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
    }
    
    func reloadTableView() {
        self.tasksTableView.reloadData()
    }
    
    // MARK: - Data Source Helper Methods
    
    func numberOfActionables(_ section:Int) -> Int {
        return self.items[section].count
    }
    
    /// get the actionable for the section and the row in the section
    ///
    /// - Parameter path: the path with section and row
    /// - Returns: index actionable
    func itemForIndexPath(path: IndexPath) -> ActionableItem {
        return self.items[path.section][path.row]
    }
    
    /// retrieve the estimated starting time for a path
    ///
    /// - Parameter path: the path
    /// - Returns: the starting time for the cell
    func estimatedStartingTime(forPath path: IndexPath) -> ActionableTimeInfo? {
        guard let startingTimes = self.startingTimes else {
            return nil
        }
        
        return startingTimes[path.section][path.row]
    }
    
    /// retrieve the index path of all task cells, which are in progess
    ///
    /// - Returns: array of index paths
    func indexPathsInProgress() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let date = Date()
        
        for sectionTuple in self.items.enumerated() {
            for actionableTuple in sectionTuple.element.enumerated() {
                let item = actionableTuple.element
                if item.actionable.isProgressing(atDate: date) {
                    indexPaths.append(IndexPath(row: actionableTuple.offset, section: sectionTuple.offset))
                }
            }
        }
        
        return indexPaths
    }
    
    
    // MARK: - ActionableTableCellDelegate
    
    func actionableStateChangeDesired(item: ActionableItem) {
        do {
            try switchBehavior(item: item, date: Date(), behavior: .state)
        }
        catch let error {
            delegate.showNotification(forError: error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.requestForEdit(actionable: self.itemForIndexPath(path: indexPath).actionable)
    }
    
 
}
