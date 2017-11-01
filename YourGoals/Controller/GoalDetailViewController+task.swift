//
//  GoalDetailViewController+task.swift
//  YourGoals
//
//  Created by André Claaßen on 28.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension GoalDetailViewController {
    
    // MARK: - task handling
    
    func switchProgress(forTask task: Task) throws {
        let date = Date()
        let progressManager = TaskProgressManager(manager: self.manager)
        if task.isProgressing(atDate: date) {
            try progressManager.stopProgress(forTask: task, atDate: date)
        } else {
            try progressManager.startProgress(forTask: task, atDate: date)
        }
        self.tasksTableView.reloadData()
        self.configure(goal: goal)
        self.delegate?.goalChanged()
    }
    
    func switchState(forTask task: Task) throws {
        let date = Date()
        let stateManager = TaskStateManager(manager: self.manager)
        if task.taskIsActive() {
            try stateManager.setTaskState(task: task, state: .done, atDate: date)
        } else {
            try stateManager.setTaskState(task: task, state: .active, atDate: date)
        }
        self.tasksTableView.reloadData()
        self.configure(goal: goal)
        self.delegate?.goalChanged()
    }
    
    func switchCommitment(forTask task: Task) throws {
        let date = Date()
        let commitManager = TaskCommitmentManager(manager: self.manager)
        if task.commitingState(forDate: date) == .committedForDate {
            try commitManager.normalize(task: task)
        } else {
            try commitManager.commit(task: task, forDate: date)
        }
        self.tasksTableView.reloadData()
        self.delegate?.commitmentChanged()
    }
}
