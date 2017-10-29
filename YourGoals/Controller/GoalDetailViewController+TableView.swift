//
//  GoalDetailViewController+TableView.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit
import LongPressReorder

extension GoalDetailViewController: UITableViewDataSource, UITableViewDelegate, TaskTableCellDelegate {
    
    func configure( tableView: UITableView, withGoal goal: Goal) throws {
        try retrieveOrderedTasks()
        tableView.registerReusableCell(TaskTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        self.reorderTableView = LongPressReorderTableView(tableView, selectedRowScale: SelectedRowScale.medium)
        self.reorderTableView.delegate = self
        scheduleTimerWithTimeInterval(tableView: tableView)
        self.reorderTableView.enableLongPressReorder()
    }
    
    
    // MARK: - Timer Handling
    
    func scheduleTimerWithTimeInterval(tableView: UITableView) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTaskInProgess), userInfo: tableView, repeats: true)
        timerPaused = false
    }
    
    @objc func updateTaskInProgess(timer:Timer) {
        guard !self.timerPaused else {
            return
        }
        
        guard let tableView = timer.userInfo as? UITableView else {
            assertionFailure("couldn't extract tableView from userInfo")
            return
        }
    
        let paths = indexPathsInProgress()
        if paths.count > 0 {
            tableView.beginUpdates()
            tableView.reloadRows(at: paths, with: UITableViewRowAnimation.none)
            tableView.endUpdates()
        }
    }

    // MARK: - Data Source Methods
    
    func retrieveOrderedTasks() throws {
        self.tasksOrdered = try TaskOrderManager(manager: self.manager).tasksByOrder(forGoal: goal)
    }
    
    func numberOfTasks() -> Int {
        return self.tasksOrdered.count
    }

    func taskForIndexPath(path: IndexPath) -> Task {
        return self.tasksOrdered[path.row]
    }
    
    func updateTaskOrder(initialIndex: IndexPath, finalIndex: IndexPath) throws {
        guard initialIndex != finalIndex else {
            NSLog("no update of order neccessary")
            return
        }
        
        let taskOrderManager = TaskOrderManager(manager: self.manager)
        self.tasksOrdered = try taskOrderManager.updateTaskPosition(tasks: self.tasksOrdered, fromPosition: initialIndex.row, toPosition: finalIndex.row)
    }
    
    /// retrieve the index path of all task cells, which are in progess
    ///
    /// - Returns: array of index paths
    func indexPathsInProgress() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let date = Date()
        
        for tuple in self.tasksOrdered.enumerated() {
            let task = tuple.element
            if task.isProgressing(atDate: date) {
                indexPaths.append(IndexPath(row: tuple.offset, section: 0))
            }
        }
        
        return indexPaths
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskTableViewCell.dequeue(fromTableView: tableView, atIndexPath: indexPath)
        let task = self.taskForIndexPath(path: indexPath)
        cell.configure(task: task, delegate: self)
        configure(swipeableCell: cell)
        return cell
    }
    
    // MARK: - TaskTableCellDelegate
    
    func taskStateChangeDesired(task: Task) {
        do {
            try self.switchState(forTask: task)
        }
        catch let error {
            showNotification(forError: error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editTask = self.taskForIndexPath(path: indexPath)
        performSegue(withIdentifier: "presentEditTask", sender: self)
    }
    
    // MARK: - Reorder handling
    
    override func startReorderingRow(atIndex indexPath: IndexPath) -> Bool {
        self.timerPaused = true
        return true
    }
    
    override func reorderFinished(initialIndex: IndexPath, finalIndex: IndexPath) {
        do {
            NSLog("reorder finished: init:\(initialIndex) final:\(finalIndex)")
            try updateTaskOrder(initialIndex: initialIndex, finalIndex: finalIndex)
            NSLog("core data store updateted")
            self.timerPaused = false
        }
        catch let error {
            self.showNotification(forError: error)
        }
    }
}
