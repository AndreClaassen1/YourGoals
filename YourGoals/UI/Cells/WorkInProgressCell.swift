//
//  WorkInProgressCell.swift
//  YourGoals
//
//  Created by André Claaßen on 01.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class WorkInProgressCell: MGSwipeTableCell, ActionableCell {

    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var timeAlreadySpent: UILabel!
    
    let colorCalculator = ColorCalculator(colors: [UIColor.red, UIColor.yellow, UIColor.green])
    
    
    var panGesture:UIPanGestureRecognizer!
    var taskProgressManager:TaskProgressManager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Factory Method
    
    /// dequeue a WorkInProgress cell from the table view
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: index path
    /// - Returns: the work in progress cell
    internal static func dequeue(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> WorkInProgressCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkInProgressCell", for: indexPath) as? WorkInProgressCell else {
            fatalError("*** Failed to dequeue WorkInProgressCell ***")
        }
        
        return cell
    }
    
    @IBAction func minusTimerTouched(_ sender: Any) {
        try? self.taskProgressManager.changeTaskSize(forTask: self.actionable, delta: -15.0)
        showRemainingTime(date: Date())
    }
    
    @IBAction func plusTimerTouched(_ sender: Any) {
        try? self.taskProgressManager.changeTaskSize(forTask: self.actionable, delta: 15.0)
        showRemainingTime(date: Date())
    }
    
    // MARK: Actionable Cell Protocol
    
    var actionable: Actionable!
    
    @objc
    func handlePan(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        
        NSLog("handle pan called with \(translation) in view size \(self.frame.size)")
        
    }
    
    func showRemainingTime(date: Date) {
        self.remainingTimeLabel.text = actionable.calcRemainingTimeInterval(atDate: date).formattedAsString()
        self.backgroundColor = self.colorCalculator.calculateColor(percent: CGFloat(actionable.calcRemainingPercentage(atDate: date)))
    }
    
    func configure(manager: GoalsStorageManager, actionable: Actionable, forDate date: Date, delegate: ActionableTableCellDelegate) {
        self.taskProgressManager = TaskProgressManager(manager: manager)
        self.isUserInteractionEnabled = true
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.panGesture.delegate = self
      //  self.addGestureRecognizer(self.panGesture)
        self.actionable = actionable
        self.taskLabel.text = actionable.name
        self.goalLabel.text = actionable.goal?.name ?? "No goal set"
        showRemainingTime(date: date)
        let progress = actionable.calcProgressDuration(atDate: date) ?? 0.0
        self.timeAlreadySpent.text = "Time already spent \(progress.formattedAsString())"
    }
}
