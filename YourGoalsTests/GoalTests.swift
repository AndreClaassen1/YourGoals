//
//  GoalTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 05.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals
class GoalTests: StorageTestCase {
   
    func strategyWithUserGoals() -> Goal {
        let strategyManager = StrategyManager(manager: self.manager)
        let strategy = try! strategyManager.assertValidActiveStrategy()
        let _ = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: "Goal 1"))
        let _ = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: "Goal 2"))
        return strategy
    }
    
    /// test all goals
    func testAllGoals() {
        // setup 2 user goals and one implicit today goal
        let strategy = strategyWithUserGoals()
        
        // act
        let goals = strategy.allGoals()
        
        // tests
        XCTAssertEqual(3, goals.count, "2 user goals + 1 Today Goal")
    }
    
    /// test all goals but I want only the today goal back
    func testAllGoalsWithToday() {
        // setup 2 user goals and one implicit today goal
        let strategy = strategyWithUserGoals()
        
        // act
        let goals = strategy.allGoals(withTypes: [GoalType.todayGoal])
        
        // tests
        XCTAssertEqual(1, goals.count, "1 Today Goal")
        XCTAssertEqual(GoalType.todayGoal, goals[0].goalType())
    }
}
