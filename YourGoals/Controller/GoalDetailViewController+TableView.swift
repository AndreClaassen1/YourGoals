//
//  GoalDetailViewController+TableView.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension GoalDetailViewController: UITableViewDataSource, UITableViewDelegate, TaskTableCellDelegate {
    
    func configure( tableView: UITableView) {
        tableView.registerReusableCell(TaskTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        scheduleTimerWithTimeInterval(tableView: tableView)
    }
    
    // MARK: - Timer Handling
    
    func scheduleTimerWithTimeInterval(tableView: UITableView) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTaskInProgess), userInfo: tableView, repeats: true)
    }
    
    @objc func updateTaskInProgess(timer:Timer) {
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
    
    func numberOfTasks() -> Int {
        return self.goal?.allTasks().count ?? 0
    }

    func taskForIndexPath(path: IndexPath) -> Task {
        return self.goal?.allTasks()[path.row] ?? Task()
    }
    
    /// retrieve the index path of all task cells, which are in progess
    ///
    /// - Returns: array of index paths
    func indexPathsInProgress() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let date = Date()
        
        guard let tasks = self.goal?.allTasks() else {
            NSLog("warning: no goal available")
            return []
        }
        
        for tuple in tasks.enumerated() {
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
}
