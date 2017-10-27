//
//  GoalDetailViewController+TableView.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension GoalDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configure( tableView: UITableView) {
        tableView.registerReusableCell(TaskTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfTasks() -> Int {
        return self.goal?.allTasks().count ?? 0
    }

    func taskForIndexPath(path: IndexPath) -> Task {
        return self.goal?.allTasks()[path.row] ?? Task()
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
        cell.configure(task: task)
        configure(swipeableCell: cell)
        return cell
    }
}
