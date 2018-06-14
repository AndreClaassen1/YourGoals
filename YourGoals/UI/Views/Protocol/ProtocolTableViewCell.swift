//
//  ProtocolTableViewCell.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

class ProtocolTableViewCell: UITableViewCell {

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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
