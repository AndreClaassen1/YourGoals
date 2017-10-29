//
//  TaskTableViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import MGSwipeTableCell


protocol TaskTableCellDelegate {
    func taskStateChangeDesired(task:Task)
}

class TaskTableViewCell: MGSwipeTableCell {
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var workingTimeLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    
    var task:Task!
    var delegateTaskCell: TaskTableCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        checkBoxButton.setImage(UIImage(named: "TaskCircle"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "TaskChecked"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Factory Method
    
    internal static func dequeue(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> TaskTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            fatalError("*** Failed to dequeue TaskTableViewCell ***")
        }
        
        return cell
    }
    
    @IBAction func checkBoxAction(_ sender: Any) {
        delegateTaskCell.taskStateChangeDesired(task: self.task)
    }
    
    // MARK: - Content
    
    func showTaskState(state: TaskState) {
        switch state {
        case .active:
            self.checkBoxButton.isSelected = false
        case .done:
            self.checkBoxButton.isSelected = true
        }
    }
    
    func showTaskProgress(isProgressing: Bool) {
        self.contentView.backgroundColor = isProgressing ? UIColor.green : UIColor.white
    }
    
    func stringFromTime(interval ti: TimeInterval) -> String {
        let seconds = Int(ti.truncatingRemainder(dividingBy: 60))
        let minutes = Int((ti / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int(ti / 3600)
        
        let result = String(format: "%d:%0.2d:%0.2d", hours, minutes, seconds)
        return result
    }
    
    func showWorkingTime(task: Task) {
        let progress = task.calcProgressDuration(atDate: Date())
        if progress == 0.0 {
            self.workingTimeLabel.text = nil
            return
        }
        
        self.workingTimeLabel.text = stringFromTime(interval: progress)
    }
    
    /// show the content of the task in this cell
    ///
    /// - Parameter task: a task
    func configure(task: Task, delegate: TaskTableCellDelegate) {
        self.task = task
        self.delegateTaskCell = delegate
        showTaskState(state: task.getTaskState())
        showTaskProgress(isProgressing: task.isProgressing(atDate: Date()))
        showWorkingTime(task: task)
        taskDescriptionLabel.text = task.name
        
        
        if let goalName = task.goal?.name {
            goalDescriptionLabel.text = "Goal: \(goalName)"
            goalDescriptionLabel.isHidden = false
        } else {
            goalDescriptionLabel.isHidden = true
        }
    }
}
