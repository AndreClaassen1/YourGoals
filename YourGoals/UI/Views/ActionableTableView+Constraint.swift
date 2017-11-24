//
//  ActionableTableView+Constraint.swift
//  YourGoals
//
//  Created by André Claaßen on 14.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension ActionableTableView {
    
    func configure(constraint: NSLayoutConstraint) {
        self.constraint = constraint
        self.constraintOffset = constraint.constant - self.tasksTableView.contentSize.height
        self.tasksTableView.addObserver(self, forKeyPath: "contentSize", options:[ .new, .old, .prior ] , context: nil)
    }
    
    /// detect any change of the contentSize of the table view
    ///
    /// - Parameters:
    ///   - keyPath: should be contentsize
    ///   - object: ignored
    ///   - change: .new, .prior, .old
    ///   - context: ignored
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            guard let constraint = self.constraint else {
                NSLog("key observer for contentSize without a constraint")
                return
            }
            
            // modify the constraint
            constraint.constant = self.tasksTableView.contentSize.height + self.constraintOffset
        }
    }
}
