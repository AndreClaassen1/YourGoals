//
//  ActionableInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//
import Foundation

/// a view model representation an actionable (task or habit)
struct ActionableInfo {
    /// its a trap, habit or a task
    let type:ActionableType
    
    /// the name of the actionabe
    let name:String?
    
    /// commit date for tasks
    let commitDate:Date?
    
    /// changed goal
    let parentGoal:Goal?
    
    /// initialize the actionable with the needed values
    /// - Parameters:
    ///   - type: type of the actionable: task or hapti
    ///   - name: name of the actionable
    ///   - commitDate: commit date (only for tasks)
    ///   - parentGoal: parentGoal
    init(type: ActionableType, name:String?, commitDate:Date? = nil, parentGoal:Goal? = nil ){
        self.type = type
        self.name = name
        self.commitDate = commitDate
        self.parentGoal = parentGoal
    }
    
    /// initialize the info with a valid actionable object
    ///
    /// - Parameter actionable: the actionable object
    init(actionable:Actionable) {
        self.type = actionable.type
        self.name = actionable.name
        self.commitDate = actionable.commitmentDate
        self.parentGoal = actionable.goal
    }
}
