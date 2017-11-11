//
//  Task+Actionable.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Task:Actionable {
    
    /// this is a task
    
    var type: ActionableType {
        return .task
    }
    
    func checkedState(forDate date: Date) -> ActionableState {
        return self.getTaskState()
    }
    
}
