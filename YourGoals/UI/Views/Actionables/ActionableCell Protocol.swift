//
//  ActionableCell Protocol.swift
//  YourGoals
//
//  Created by André Claaßen on 21.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation


/// the user
protocol ActionableTableCellDelegate {
    func actionableStateChangeDesired(item: ActionableItem)
}

/// protocol for the configuration of the actionable for the table view
protocol ActionableCell {
    func configure(manager: GoalsStorageManager, item: ActionableItem, forDate date: Date, estimatedStartingTime time: ActionableTimeInfo?,  delegate: ActionableTableCellDelegate)
    var item:ActionableItem! { get }
}
