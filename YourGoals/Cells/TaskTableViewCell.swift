//
//  TaskTableViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import MGSwipeTableCell


class TaskTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var taskCircleImageView: UIImageView!
    @IBOutlet weak var workingTimeLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    
    var task:Task!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Factory Method
    
    internal static func dequeue(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> TaskTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TaskTableViewCell else {
            fatalError("*** Failed to dequeue TaskTableViewCell ***")
        }
        
        return cell
    }
    
    // MARK: - Content
    
    func showTaskState(state: TaskState) {
        switch state {
        case .active:
            taskCircleImageView.image = UIImage(named: "TaskCircle")
            break
        case .done:
            taskCircleImageView.image = UIImage(named: "TaskChecked")
            break
        }
    }
    
    /// show the content of the task in this cell
    ///
    /// - Parameter task: a task
    func configure(task: Task) {
        self.task = task
        showTaskState(state: task.getTaskState())
        taskDescriptionLabel.text = task.name
        if let goalName = task.goal?.name {
            goalDescriptionLabel.text = "Goal: \(goalName)"
            goalDescriptionLabel.isHidden = false
        } else {
            goalDescriptionLabel.isHidden = true
        }
    }
}
