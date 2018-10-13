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
    
    /// size of the Actionable in Minutes
    let size:Float
    
    /// changed goal
    let parentGoal:Goal?
    
    /// a set of repetitions
    let repetitions:Set<ActionableRepetition>?
    
    /// the url of the share task
    let url:String?
    
    /// an image of the share task
    let imageData:Data?
    
    /// initialize the actionable with the needed values
    /// - Parameters:
    ///   - type: type of the actionable: task or hapti
    ///   - name: name of the actionable
    ///   - commitDate: commit date (only for tasks)
    ///   - parentGoal: parentGoal
    ///   - size: size of the task (only for tasks). nil makes a default size of 30 Minutes
    ///   - repetetions: a set of repetitions like sunday, weekday, monday, etc.
    init(type: ActionableType, name:String?, commitDate:Date? = nil, parentGoal:Goal? = nil, size:Float? = nil,
         url: String? = nil, imageData: Data? = nil,
         repetitions:Set<ActionableRepetition>? = nil) {
        self.type = type
        self.name = name
        self.commitDate = commitDate?.day()
        self.parentGoal = parentGoal
        self.size = size ?? 30.0
        self.url = url
        self.imageData = imageData
        self.repetitions = repetitions
    }
    
    /// initialize the info with a valid actionable object
    ///
    /// - Parameter actionable: the actionable object
    init(actionable:Actionable) {
        self.type = actionable.type
        self.name = actionable.name
        self.commitDate = actionable.commitmentDate
        self.parentGoal = actionable.goal
        self.size = actionable.size
        self.imageData = actionable.imageData
        self.url = actionable.url
        self.repetitions = actionable.repetitions
    }
}
