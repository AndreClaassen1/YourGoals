//
//  ActionableTableView+TableView.swift
//  YourGoals
//
//  Created by André Claaßen on 19.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UIKit
import MGSwipeTableCell

extension ActionableTableView {
    
    func configureTaskTableView(_ tableView: UITableView) {
        tableView.registerReusableCell(ActionableTableCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 48.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count == 0 ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var n = numberOfActionables(section)
        if let reorderInfo = self.reorderInfo {
            n += reorderInfo.offsetForDraggingRow(section)
        }
        
        return n
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.count > section  else {
            return nil
        }
        
        return sections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = Date()
        var actionableCell:ActionableCell!
        let actionable = self.actionableForIndexPath(path: indexPath)
        if actionable.isProgressing(atDate: date) {
            actionableCell = ActionableTableCell.dequeue(fromTableView: tableView, atIndexPath: indexPath)
        } else {
            actionableCell = ActionableTableCell.dequeue(fromTableView: tableView, atIndexPath: indexPath)
        }
        
        let startingTime = self.estimatedStartingTime(forPath: indexPath)
        
        actionableCell.configure(manager: self.manager, actionable: actionable, forDate: Date(), estimatedStartingTime: startingTime, delegate: self)
        
        configure(swipeableCell: actionableCell as! MGSwipeTableCell)
        return actionableCell as! UITableViewCell
    }
}
