//
//  TestDataCreator.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

class TestDataCreator:StorageManagerWorker {
    
    /// create a goal for unit testing
    ///
    /// - Parameter name: name of the goal
    /// - Returns: the goal
    func createGoal(name: String) -> Goal {
        return try! GoalFactory(manager: self.manager).create(name: name, prio: 1, reason: "test reasons", startDate: Date.minimalDate, targetDate: Date.maximalDate, image: nil)
    }
}
