//
//  GoalDetailViewController+TableView.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension GoalDetailViewController {
    
    func configureTableView( _ tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerReusableCell(TaskTableViewCell.self)
    }
    
    func numberOfTasks() -> Int {
        return self.goal?.allTasks().count ?? 0
    }

    func taskForIndexPath(path: IndexPath) -> Task {
        return self.goal?.allTasks()[path.row] ?? Task()
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfTasks()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskTableViewCell.dequeue(fromTableView: tableView, atIndexPath: indexPath)
        let task = self.taskForIndexPath(path: indexPath)
        cell.show(task: task)
        return cell
    }
}
