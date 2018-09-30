//
//  ProtocolTableViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

/// a table view cell for displaying a protocol entry in the done history
class ProtocolTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// factory method to create a ProtocolTableViewCell with type checking
    ///
    /// - Parameters:
    ///   - tableView: table view cell
    ///   - indexPath: the index path
    /// - Returns: a hopefully valid ProtocolTableViewCell
    internal static func dequeue(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> ProtocolTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProtocolTableViewCell", for: indexPath) as? ProtocolTableViewCell else {
            fatalError("*** Failed to dequeue ProtocolTableViewCell ***")
        }
        
        return cell
    }
    
    /// create a description string which includes the progress made on the goal so far.
    ///
    /// - Parameters:
    ///   - protocolInfo: the protocol info with the percentage of the progress
    ///   - date: the date as the foundation for the calculation
    /// - Returns: a formatted string: "You made 3% progress on your goal!"
    func progressDescription(from protocolInfo: ProtocolProgressInfo, onDate date:Date) -> String {
        let percentage = protocolInfo.progress(onDate: date)
        if percentage == 0.0 {
            return "You made no progress on your goal!"
        } else {
            let percentageString = String.localizedStringWithFormat("%.2f", percentage * 100.0)
            return "You made \(percentageString)% progress on your goal!"
        }
    }
    
    /// confiure the cell with the values of the entry
    func configure(protocolInfo:ProtocolProgressInfo, onDate date:Date) {
        titleLabel.text = protocolInfo.title
        durationLabel.text = protocolInfo.timeRange(onDate: date)
        descriptionLabel.text = progressDescription(from: protocolInfo, onDate: date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
