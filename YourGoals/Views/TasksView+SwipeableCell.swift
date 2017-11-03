//
//  TasksView+SwipeableCell.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import MGSwipeTableCell

extension TasksView: MGSwipeTableCellDelegate {

    
    // MARK: - configuration of the swipeable cell
    
    func configure(swipeableCell cell:MGSwipeTableCell) {
        cell.delegate = self
    }
    
    // MARK: - swipe button handling
    
    func switchProgress(forTask task: Task) throws {
        let date = Date()
        let progressManager = TaskProgressManager(manager: self.manager)
        if task.isProgressing(atDate: date) {
            try progressManager.stopProgress(forTask: task, atDate: date)
        } else {
            try progressManager.startProgress(forTask: task, atDate: date)
        }
        self.tasksTableView.reloadData()
        self.delegate.goalChanged(goal: task.goal!)
        self.delegate.progressChanged(task: task)
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
        self.delegate.goalChanged(goal: task.goal!)
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
        self.delegate.commitmentChanged()
    }
    
    
    // MARK: - Swipe Cell creator funciton
    
    /// create a swipe button for starting/stoping making progress
    ///
    /// - Parameter task: a task
    /// - Returns: a configured MGSwipeButton
    func createSwipeButtonForProgress(task: Task) -> MGSwipeButton {
        let isProgressing = task.isProgressing(atDate: Date())
        let title = isProgressing ? "Stop task" : "Start task"
        let backgroundColor = isProgressing ? UIColor.red : UIColor.green
        let button = MGSwipeButton(title: title, backgroundColor: backgroundColor)
        return button
    }
    
    /// crate a swipe button for the active/done state
    ///
    /// - Parameter task: a task
    /// - Returns: a properly configured swipe button for the active / done state
    func createSwipeButtonForState(task: Task) -> MGSwipeButton {
        let title = task.taskIsActive() ? "Task Done" : "Task Open"
        return MGSwipeButton(title: title, backgroundColor: UIColor.blue)
    }
    
    /// create a swipe button for normalize or / comitting a task
    ///
    /// - Parameter task: the task
    /// - Returns: a properly configured swipe button for the normalize / committing state
    func createSwipeButtonForCommitment(task: Task) -> MGSwipeButton {
        let commitingState = task.commitingState(forDate: Date()) == .committedForDate
        let title = commitingState ? "Normalize": "Committed!"
        let backgroundColor = commitingState ? UIColor.gray: UIColor.yellow
        let button =  MGSwipeButton(title: title, backgroundColor: backgroundColor)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }
    
    // MARK: - MGSwipeTableCellDelegate
    
    func swipeTableCellWillBeginSwiping(_ cell: MGSwipeTableCell) {
        self.timerPaused = true
    }
    
    func swipeTableCellWillEndSwiping(_ cell: MGSwipeTableCell) {
        self.timerPaused = false
    }
    
    /// show the swipe buttons for the task
    ///
    /// - Parameters:
    ///   - cell: task
    ///   - direction: direction to swipe - from left to right or right to left
    ///   - swipeSettings: several settings
    ///   - expansionSettings: expansion settings
    /// - Returns: an array of MGSwipeButtons
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        guard let taskCell = cell as? TaskTableViewCell else {
            NSLog("illegal cell type: \(cell)")
            return nil
        }
        
        guard let task = taskCell.task else {
            NSLog("could not extract task out of cell: \(taskCell)")
            return nil
        }
        
        
        swipeSettings.transition = MGSwipeTransition.border
        expansionSettings.buttonIndex = 0
        
        if direction == MGSwipeDirection.leftToRight {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2
            return [createSwipeButtonForProgress(task: task)]
        }
        else {
            return [createSwipeButtonForCommitment(task: task), createSwipeButtonForState(task: task)]
        }
    }
    
    /// handle a tapped swipe button
    ///
    /// - Parameters:
    ///   - cell: for task cell
    ///   - index: index of the button, if there are several butotns
    ///   - direction: left to right or right ot left
    ///   - fromExpansion:
    /// - Returns: true for old good handlign
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        do {
            guard let taskCell = cell as? TaskTableViewCell else {
                NSLog("illegal cell type: \(cell)")
                return true
            }
            
            guard let task = taskCell.task else {
                NSLog("could not extract task out of cell: \(taskCell)")
                return true
            }
            
            switch direction {
            case .leftToRight:
                try switchProgress(forTask: task)
                break
                
            case .rightToLeft:
                switch index {
                case 0:
                    try switchCommitment(forTask: task)
                case 1:
                    try switchState(forTask: task)
                default:
                    assertionFailure("not processable index for swipe cell: \(index)")
                    
                }
                break
            }
        }
        catch let error {
            self.delegate?.showNotification(forError: error)
        }
        
        return true
    }
}
