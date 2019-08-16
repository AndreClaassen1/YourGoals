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

extension ActionableTableViewDelegate {
    
    
    /// register default table view cell
    ///
    /// - Parameter tableView: <#tableView description#>
    func registerCells(inTableView tableView: UITableView) {
        tableView.registerReusableCell(ActionableTableCell.self)
    }
    
    /// default implementation retrieves the actionable cell
    ///
    /// - Parameters:
    ///   - fromTableView: table view
    ///   - atIndexPath: index patch
    /// - Returns: a table view cell which implements the actionable cell protocoll
    func dequeueActionableCell(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> ActionableCell {
        let actionableCell = ActionableTableCell.dequeue(fromTableView: tableView, atIndexPath: indexPath)
        return actionableCell
    }
}


extension ActionableTableView {
    
    func configureTaskTableView(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    /// if a section has no actionables, then we've got an empty cell to support dragging.
    ///
    /// - Parameter indexPath: index path to test
    /// - Returns: if it is an empty cell
    func isEmptyCell(_ indexPath:IndexPath) -> Bool {
        return numberOfActionables(indexPath.section) == 0
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count == 0 ? 1 : sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var n = numberOfActionables(section)
       
        // logic for empty sectins
        if self.sections.count > 0 && n == 0 {
            n += 1
        }
        
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
    
    /// show the actionable item in a table view cell
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path
    /// - Returns: a fully functionable table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // logic for empty cell in sections eg. No Items for this section
        if isEmptyCell(indexPath) {
            var emptyTableCell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            
            if emptyTableCell == nil {
                emptyTableCell = UITableViewCell(style: .default, reuseIdentifier: "emptyCell")
            }
            emptyTableCell.textLabel?.text = "noch nichts geplant"

            return emptyTableCell
        }
        
        
        let item = self.itemForIndexPath(path: indexPath)
        let actionableCell = self.delegate.dequeueActionableCell(fromTableView: tableView, atIndexPath: indexPath)
        actionableCell.configure(manager: self.manager, theme: self.theme, item: item, forDate: Date(), delegate: self)
        
        configure(swipeableCell: actionableCell.swipeTableCell)
        return actionableCell.swipeTableCell
    }
}
