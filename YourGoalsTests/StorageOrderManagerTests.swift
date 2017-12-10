//
//  StorageOrderManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 05.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

/// tests for the StorageOrderManager class
class StorageOrderManagerTests: StorageTestCase {
    
    /// test the goalsByPrio() method
    func testGoalsByOrder() {
        // setup
        let strategyManager = StrategyManager(manager: self.manager)
        let _ = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: "Goal 1", prio: 1))
        let _ = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: "Goal 3", prio: 3))
        let _ = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: "Goal 2", prio: 2))
        
        // act
        let strategyOrderManager = StrategyOrderManager(manager: self.manager)
        let goalsOrdered = try! strategyOrderManager.goalsByPrio(withTypes: [.userGoal])
        
        // test
        XCTAssertEqual(3, goalsOrdered.count)
        XCTAssertEqual("Goal 1", goalsOrdered[0].name)
        XCTAssertEqual("Goal 2", goalsOrdered[1].name)
        XCTAssertEqual("Goal 3", goalsOrdered[2].name)
    }
}

