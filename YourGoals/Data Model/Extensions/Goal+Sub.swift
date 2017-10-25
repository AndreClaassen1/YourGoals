//
//  Goal+Subgoals.swift
//  YourGoals
//
//  Created by André Claaßen on 25.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Goal {
    func allGoals() -> [Goal] {
        return subGoals?.allObjects as? [Goal] ?? []
    }
    
    func allTasks() -> [Task] {
        return tasks?.allObjects as? [Task] ?? []
    }
}
