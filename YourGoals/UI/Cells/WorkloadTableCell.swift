//
//  WorkloadViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 08.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

class WorkloadViewCell: UITableViewCell {
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var tasksLeftLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// dequeue a WorkInProgress cell from the table view
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: index path
    /// - Returns: the work in progress cell
    internal static func dequeue(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> WorkloadViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkloadViewCell", for: indexPath) as? WorkloadViewCell else {
            fatalError("*** Failed to dequeue WorkloadViewCell ***")
        }
        
        return cell
    }
    
}
