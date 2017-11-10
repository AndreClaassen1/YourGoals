//
//  ActionableTableCell.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol ActionableTableCellDelegate {
    func actionableStateChangeDesired(actionable:Actionable)
}

/// a table cell for displaying habits or tasks. experimental
class ActionableTableCell: MGSwipeTableCell {
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var workingTimeLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var commmittingDateLabel: UILabel!
    
    var actionable:Actionable!
    var delegateTaskCell: ActionableTableCellDelegate!
    
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
    
    internal static func dequeue(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> ActionableTableCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActionableTableCell", for: indexPath) as? ActionableTableCell else {
            fatalError("*** Failed to dequeue ActionableTableCell ***")
        }
        
        return cell
    }
    
    @IBAction func checkBoxAction(_ sender: Any) {
        delegateTaskCell.actionableStateChangeDesired(actionable: self.actionable)
    }
    
    // MARK: - Content
    
    func show(state: ActionableState) {
        switch state {
        case .active:
            self.checkBoxButton.isSelected = false
        case .done:
            self.checkBoxButton.isSelected = true
        }
    }
    
    /// show the task progress state
    ///
    /// - Parameters:
    ///   - isProgressing: task is currently progressing
    func showTaskProgress(isProgressing: Bool) {
        self.contentView.backgroundColor = isProgressing ? UIColor.green : UIColor.white
    }
    
    /// show the date for committing and its state in the date label
    ///
    /// - Parameters:
    ///   - state: the state of the task
    ///   - date: date of the commitment
    func showTaskCommittingState(state: CommittingState, forDate date: Date?) {
        
        guard let date = date else {
            self.commmittingDateLabel.isHidden = true
            return
        }

        switch state {
        case .committedForDate:
            self.commmittingDateLabel.text = date.formattedWithTodayTommorrowYesterday()
            self.commmittingDateLabel.isHidden = false
            self.commmittingDateLabel.textColor  = UIColor.darkGreen
            
        case .committedForPast:
            self.commmittingDateLabel.text = date.formattedWithTodayTommorrowYesterday()
            self.commmittingDateLabel.isHidden = false
            self.commmittingDateLabel.textColor = UIColor.darkRed
            
        case .notCommitted:
            self.commmittingDateLabel.isHidden = true
        }
    }
    
    /// get a human readable string for a time interval (:ugly:)
    ///
    /// - Parameter ti: time interval
    /// - Returns: string representation in format 0:00:00
    func stringFromTime(interval ti: TimeInterval) -> String {
        let seconds = Int(ti.truncatingRemainder(dividingBy: 60))
        let minutes = Int((ti / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int(ti / 3600)
        
        let result = String(format: "%d:%0.2d:%0.2d", hours, minutes, seconds)
        return result
    }
    
    /// show the working time on this task.
    ///
    /// - Parameter task: task
    func showWorkingTime(actionable: Actionable) {
        guard let progress = actionable.calcProgressDuration(atDate: Date()) else {
            self.workingTimeLabel.text = nil
            return
        }
        
        self.workingTimeLabel.text = stringFromTime(interval: progress)
    }
    
    /// show the content of the task in this cell
    ///
    /// - Parameter task: a task
    func configure(actionable: Actionable, forDate date: Date, delegate: ActionableTableCellDelegate) {
        self.actionable = actionable
        self.delegateTaskCell = delegate
        show(state: actionable.checkedState(forDate: date))
        showTaskProgress(isProgressing: actionable.isProgressing(atDate: date))
        showTaskCommittingState(state: actionable.committingState(forDate: date), forDate: actionable.commitmentDate)
        showWorkingTime(actionable: actionable)
        taskDescriptionLabel.text = actionable.name
        
        if let goalName = actionable.goal?.name {
            goalDescriptionLabel.text = "Goal: \(goalName)"
            goalDescriptionLabel.isHidden = false
        } else {
            goalDescriptionLabel.isHidden = true
        }
    }
}
