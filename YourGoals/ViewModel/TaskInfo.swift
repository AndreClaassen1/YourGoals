//
//  TaskInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

enum TaskInfoError : Error {
    case invalidTaskNameError
}


/// a view model representation of a task
struct TaskInfo {
    let taskName:String
    
    init(taskName:String) throws {
        if taskName.isEmpty {
            throw TaskInfoError.invalidTaskNameError
        }
        
        self.taskName = taskName
    }
}
