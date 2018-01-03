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
    
    // MARK: Actionable Cell Protocol
    
    func configure(actionable: Actionable, forDate date: Date, delegate: ActionableTableCellDelegate) {
        self.taskLabel.text = actionable.name
        self.goalLabel.text = actionable.goal?.name ?? "No goal set"
        self.remainingTimeLabel.text = actionable.calcRemainingTimeInterval(atDate: date).formattedAsString()
    }
}
