//
//  GoalsModelUpdater.swift
//  YourGoals
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

protocol GoalsModelUpdateDelegate {
    func taskUpdated(task: Task)
    func taskCreated(task: Task)
    func taskRemoved(task: Task)
    
    func goalUpdated(goal: Goal)
    func goalCreatead(goal: Goal)
    func goalRemoved(goal: Goal)
}


