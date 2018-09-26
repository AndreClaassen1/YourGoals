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
    
    /// confiure the cell with the values of the entry
    func configure(protocolInfo:ProtocolProgressInfo) {
        titleLabel.text = protocolInfo.title
        durationLabel.text = protocolInfo.timeRange
        descriptionLabel.text = protocolInfo.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
