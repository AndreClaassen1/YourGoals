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
    
    /// retrieve the UIImage for the protocol progress info type
    ///
    /// - Parameter type: a doneTask, habitProgress or taskProgress
    /// - Returns: a correspondending image
    func iconImageForType(type: ProtocolProgressInfoType) -> UIImage {
        var name = "unknown"
        switch type {
        case .doneTask:
            name = "TaskChecked"
        case .habitProgress:
            name = "HabitBoxChecked"
        case .taskProgress:
            name = "TaskProgress"
        }
        
        guard let icon = UIImage(named: name) else {
            assertionFailure("there is no icon for type: \(type) and name \(name)")
            return UIImage()
        }
        return icon
    }
    
    /// confiure the cell with the values of the entry
    func configure(protocolInfo:ProtocolProgressInfo, onDate date:Date) {
        self.titleLabel.text = protocolInfo.title
        self.durationLabel.text = protocolInfo.timeRange(onDate: date)
        self.descriptionLabel.text = progressDescription(from: protocolInfo, onDate: date)
        self.protocolIcon.image = iconImageForType(type: protocolInfo.type)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
