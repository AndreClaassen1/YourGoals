//
//  ActionableTableView+Reorder.swift
//  YourGoals
//
//  Created by André Claaßen on 11.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

struct ReorderInfo {
 
    let startIndex:IndexPath
    var currentIndex:IndexPath?
    
    func offsetForDraggingRow(_ section: Int) -> Int {
        guard let currentIndex = self.currentIndex else {
            return 0
        }
        
        guard currentIndex.section != startIndex.section else {
            return 0
        }
        
        if section == startIndex.section {
            return -1
        }
        
        if section == currentIndex.section {
            return +1
        }
        
        return 0
    }
    
}

extension ActionableTableView: LongPressReorder {
    
    func updateTaskOrder(initialIndex: IndexPath, finalIndex: IndexPath) throws {
        guard initialIndex != finalIndex else {
            NSLog("no update of order neccessary")
            return
        }
        
        guard let dataSource = self.dataSource else {
            assertionFailure("you need to configure the datasource first")
            return
        }
        
        
        guard let positioning = dataSource.positioningProtocol() else {
            NSLog("no repositioning protocol found")
            return
        }
        
        
        if initialIndex.section == finalIndex.section {
            let items = self.items[initialIndex.section]
            try positioning.updatePosition(items: items, fromPosition: initialIndex.row, toPosition: finalIndex.row)
        } else {
            // handling for empty cells
            
            var toPosition = finalIndex.row
            if items[finalIndex.section].count < toPosition {
                toPosition = items[finalIndex.section].count
            }
            
            try positioning.moveIntoSection(item: itemForIndexPath(path: initialIndex), section: self.sections[finalIndex.section], toPosition: toPosition)
        }
        
        reload()
    }
    
    // MARK: - Reorder handling
    
    func startReorderingRow(atIndex indexPath: IndexPath) -> Bool {
        self.timerPaused = true
        guard self.items[indexPath.section].count > 0 else {
            return false
        }
        
        
        self.reorderInfo = ReorderInfo(startIndex: indexPath, currentIndex: nil)
        return true
    }
    
    func reorderFinished(initialIndex: IndexPath, finalIndex: IndexPath) {
        do {
            self.reorderInfo = nil
            NSLog("reorder finished: init:\(initialIndex) final:\(finalIndex)")
            try updateTaskOrder(initialIndex: initialIndex, finalIndex: finalIndex)
            NSLog("core data store updateted")
            self.timerPaused = false
        }
        catch let error {
            self.delegate?.showNotification(forError: error)
        }
    }
    
    func positionChanged(currentIndex: IndexPath, newIndex: IndexPath) {
        self.reorderInfo?.currentIndex = newIndex
    }
    
    func allowChangingRow(atIndex indexPath: IndexPath) -> Bool {
        return true
    }
}
