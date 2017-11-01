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

protocol TasksViewDelegate {
    func editTask(task: Task)
    func showNotification(forError error: Error)
    func goalChanged()
    func commitmentChanged()
}

enum TasksViewMode {
    case notInitialized
    case tasksForGoal
    case committedTasks
}

/// a specialized UITableView for displaying tasks
class TasksView: UIView, UITableViewDataSource, UITableViewDelegate, TaskTableCellDelegate, LongPressReorder, MGSwipeTableCellDelegate {
    

    var tasksTableView:UITableView!
    var reorderTableView: LongPressReorderTableView!
    var tasksOrdered: [Task]!
    var timer = Timer()
    var timerPaused = false
    var editTask:Task? = nil
    var mode = TasksViewMode.notInitialized
    var manager:GoalsStorageManager!
    var delegate:TasksViewDelegate!
    var goal:Goal!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func commonSetup() {
        self.tasksTableView = UITableView(frame: self.bounds)
        self.tasksTableView.registerReusableCell(TaskTableViewCell.self)
        self.reorderTableView = LongPressReorderTableView(self.tasksTableView, selectedRowScale: .big)
        self.tasksTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tasksTableView.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(self.tasksTableView)
        self.reorderTableView.delegate = self
        scheduleTimerWithTimeInterval(tableView: self.tasksTableView)
        self.reorderTableView.enableLongPressReorder()
    }

    func configure(manager:GoalsStorageManager, forGoal goal:Goal, delegate: TasksViewDelegate) {
        self.mode = .tasksForGoal
        self.goal = goal
        self.delegate = delegate
        configureTableView()
    }
    
    func configureTableView() {
        do {
            try retrieveOrderedTasks()
            self.tasksTableView.registerReusableCell(TaskTableViewCell.self)
            self.tasksTableView.delegate = self
            self.tasksTableView.dataSource = self
            self.reorderTableView = LongPressReorderTableView(self.tasksTableView, selectedRowScale: SelectedRowScale.medium)
            self.reorderTableView.delegate = self
            self.scheduleTimerWithTimeInterval(tableView: self.tasksTableView)
            self.reorderTableView.enableLongPressReorder()
        }
        catch let error {
            self.delegate.showNotification(forError: error)
        }
    }

    
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
    
    func reloadTableView() throws {
        try retrieveOrderedTasks()
        self.tasksTableView.reloadData()
    }
    
    // MARK: - Data Source Methods
    
    func retrieveOrderedTasks() throws {
        switch self.mode {
        case .notInitialized:
                assertionFailure("this view isn't initialized")
                break
        case .tasksForGoal:
            self.tasksOrdered = try TaskOrderManager(manager: self.manager).tasksByOrder(forGoal: goal)
            break
            
        case .committedTasks:
            self.tasksOrdered = try TaskCommitmentManager(manager: self.manager).committedTasks(forDate: Date())
            break
        }
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
    
    // MGSwipeTableCellDelegate
    
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
        cell.delegate = self
        return cell
    }
    
    // MARK: - TaskTableCellDelegate
    
    func taskStateChangeDesired(task: Task) {
        do {
            try self.switchState(forTask: task)
        }
        catch let error {
            delegate.showNotification(forError: error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.editTask(task: self.taskForIndexPath(path: indexPath))
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
        self.delegate.goalChanged()
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
        self.delegate.goalChanged()
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
    
}
