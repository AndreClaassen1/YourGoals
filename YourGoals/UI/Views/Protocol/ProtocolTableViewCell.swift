//
//  ProtocolTableViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

/// a table view cell for displaying a protocol entry in the protocol history
class ProtocolTableViewCell: UITableViewCell {
    @IBOutlet weak var protocolIcon: UIImageView!
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
    
    /// retrieve the UIImage for the protocol progress info type
    ///
    /// - Parameter type: a doneTask, habitProgress or taskProgress
    /// - Returns: a correspondending image
    func iconImageForType(type: ProtocolProgressInfoType) -> UIImage {
        switch type {
        case .doneTask:
            return Asset.taskChecked.image
        case .habitProgress:
            return Asset.habitBoxChecked.image
        case .taskProgress:
            return Asset.taskProgress.image
        }
    }
    
    /// confiure the cell with the values of the entry
    ///
    /// - Parameters:
    ///   - protocolInfo: a protocol info (task progress, done task, habit)
    ///   - date: a date for calculating different values
    func configure(protocolInfo:ProtocolProgressInfo, onDate date:Date) {
        self.titleLabel.text = protocolInfo.title
        self.durationLabel.text = protocolInfo.timeRange(onDate: date)
        self.descriptionLabel.text = protocolInfo.progressDescription(onDate: date)
        self.protocolIcon.image = iconImageForType(type: protocolInfo.type)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
