//
//  Tasks+Statwe.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

enum TaskState:Int16 {
    case planned = 0
    case active = 1
    case done = 2
}

extension Task {

    func setTaskState(state:TaskState) {
        self.state = state.rawValue
    }
    
    func getTaskState() -> TaskState {
        return TaskState(rawValue: self.state)!
    }
}
