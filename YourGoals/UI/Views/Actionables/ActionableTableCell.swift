//
//  ActionableTableCell.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import MGSwipeTableCell

/// the user
protocol ActionableTableCellDelegate {
    func actionableStateChangeDesired(actionable:Actionable)
}

/// protocol for the configuration of the actionable for the table view
protocol ActionableCell {
    func configure(manager: GoalsStorageManager, actionable: Actionable, forDate date: Date, estimatedStartingTime time: StartingTimeInfo?,  delegate: ActionableTableCellDelegate)
    var actionable:Actionable! { get }
}

/// a table cell for displaying habits or tasks. experimental
class ActionableTableCell: MGSwipeTableCell, ActionableCell {
    @IBOutlet weak var totalWorkingTimeLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var workingTimeLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var commmittingDateLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var pieProgressView: PieProgressView!
    @IBOutlet weak var progressViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var attachedImageView: UIImageView!
    
    var actionable:Actionable!
    var delegateTaskCell: ActionableTableCellDelegate!
    let colorCalculator = ColorCalculator(colors: [UIColor.red, UIColor.yellow, UIColor.green])
    var taskProgressManager:TaskProgressManager!
    var defaultProgressViewHeight:CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        defaultProgressViewHeight = progressViewHeightConstraint.constant
        checkBoxButton.setImage(Asset.taskCircle.image, for: .normal)
        checkBoxButton.setImage(Asset.taskChecked.image, for: .selected)
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
    
    @IBAction func clickOnURL(_ sender: Any) {
        guard let urlString = actionable.urlString else {
            NSLog("clickOnURL failed. no URL is set")
            return
        }
        
        guard let url = URL(string: urlString) else {
            NSLog("clickOnURL failed: string is not an url")
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    // MARK: - Content
    
    /// show the action state as a marked checkbox
    ///
    /// - Parameter state: .active or .done
    func show(state: ActionableState) {
        switch state {
        case .active:
            self.checkBoxButton.isSelected = false
        case .done:
            self.checkBoxButton.isSelected = true
        }
    }
    
    /// show the task progress state and resize the control for the needed height
    ///
    /// - Parameter date: show progress for date
    func showTaskProgress(forDate date: Date) {
        let isProgressing = self.actionable.isProgressing(atDate: date)
        self.progressView.isHidden = !isProgressing
        self.progressViewHeightConstraint.constant = isProgressing ? defaultProgressViewHeight : 0.0
        if isProgressing {
            let remainingPercentage = CGFloat(actionable.calcRemainingPercentage(atDate: date))
            let progressColor = self.colorCalculator.calculateColor(percent: remainingPercentage)
            if let imageData = self.actionable.imageData {
                self.contentView.backgroundColor = UIColor.white
                self.attachedImageView.image = UIImage(data: imageData)
            } else {
                self.attachedImageView.image = nil
                self.contentView.backgroundColor = progressColor.lighter(by: 75.0)
            }
            self.remainingTimeLabel.text =  self.actionable.calcRemainingTimeInterval(atDate: date).formattedAsString()
            self.pieProgressView.progress = 1.0 - remainingPercentage
            self.pieProgressView.progressTintColor = progressColor.darker()
            self.pieProgressView.fillColor = UIColor.clear
            self.pieProgressView.trackTintColor = progressColor.darker()
            self.pieProgressView.clockwise = true
        } else {
            self.contentView.backgroundColor = UIColor.white
        }
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
            self.commmittingDateLabel.textColor  = UIColor.darkGreen
            
        case .committedForFuture:
            self.commmittingDateLabel.text = date.formattedWithTodayTommorrowYesterday()
            self.commmittingDateLabel.isHidden = false
            self.commmittingDateLabel.textColor = UIColor.blue
            
        case .notCommitted:
            self.commmittingDateLabel.isHidden = true
        }
    }
    
    /// quick :hack: to change the progress of a task.
    ///
    /// - Parameter sender: self
    @IBAction func timerPlusTouched(_ sender: Any) {
        let progressingDate = Date()
        try? self.taskProgressManager.changeTaskSize(forTask: self.actionable, delta: 15.0, forDate: progressingDate)
        showTaskProgress(forDate: progressingDate)
    }
    
    /// show the working time on this task.
    ///
    /// - Parameter task: task
    func showWorkingTime(actionable: Actionable, forDate date: Date, estimatedStartingTime timeInfo: StartingTimeInfo?) {
        let tuple = TaskWorkingTimeTextCreator().getTimeLabelTexts(actionable: actionable, forDate: date, estimatedStartingTime: timeInfo )
        self.workingTimeLabel.text = tuple.workingTime
        var workingTimeTextColor = UIColor.black
        if let timeInfo = timeInfo {
            workingTimeTextColor = timeInfo.conflicting ? UIColor.red : timeInfo.fixedStartingTime ? UIColor.blue : UIColor.black
        }
        
        self.workingTimeLabel.textColor = workingTimeTextColor
        self.remainingTimeLabel.text = tuple.remainingTime
        self.totalWorkingTimeLabel.text = tuple.totalWorkingTime
    }
    
    /// adapt cell ui for a habit or a task
    ///
    /// - Parameter type: the type of the actionable
    func adaptUI(forActionableType type: ActionableType) {
        switch type {
        case .habit:
            checkBoxButton.setImage(Asset.habitBox.image, for: .normal)
            checkBoxButton.setImage(Asset.habitBoxChecked.image, for: .selected)
        case .task:
            checkBoxButton.setImage(Asset.taskCircle.image, for: .normal)
            checkBoxButton.setImage(Asset.taskChecked.image, for: .selected)
        }
    }
    
    /// show the attached url as a clickable button
    ///
    /// - Parameter url: url
    func showAttachedURL(url: String?) {
        guard let url = url else {
            self.urlButton.isHidden = true
            return
        }
        
        self.urlButton.isHidden = false
        self.urlButton.setTitle(url, for: .normal)
    }
    
    /// show the attached image as a transparent image background
    ///
    /// - Parameter data: image data
    func showAttachedImage(imageData data: Data?) {
        guard let data = data else {
            self.attachedImageView.image = nil
            self.attachedImageView.isHidden = true
            return
        }
        
        self.attachedImageView.image = UIImage(data: data)
        self.attachedImageView.isHidden = false
        self.attachedImageView.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.attachedImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    /// show the content of the task in this cell
    ///
    /// - Parameters:
    ///   - manager: the storage manager
    ///   - actionable: show the actionable in the cell
    ///   - date: for this date
    ///   - time: with this optional estimated starting time
    ///   - delegate: a delegate for call back actions
    func configure(manager: GoalsStorageManager, actionable: Actionable, forDate date: Date,
                   estimatedStartingTime time: StartingTimeInfo?,
                   delegate: ActionableTableCellDelegate) {
        self.taskProgressManager = TaskProgressManager(manager: manager)
        self.actionable = actionable
        self.delegateTaskCell = delegate
        self.taskDescriptionLabel.sizeToFit()
        adaptUI(forActionableType: actionable.type)
        show(state: actionable.checkedState(forDate: date))
        showTaskProgress(forDate: date)
        showTaskCommittingState(state: actionable.committingState(forDate: date), forDate: actionable.commitmentDate)
        showWorkingTime(actionable: actionable, forDate: date, estimatedStartingTime: time)
        showAttachedURL(url: actionable.urlString)
        showAttachedImage(imageData: actionable.imageData)
        taskDescriptionLabel.text = actionable.name
        
        if let goalName = actionable.goal?.name {
            goalDescriptionLabel.text = "Goal: \(goalName)"
            goalDescriptionLabel.isHidden = false
        } else {
            goalDescriptionLabel.isHidden = true
        }
    }
}
