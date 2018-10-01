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
   
    func createStrategyWithUserGoals(goals: [(name:String, backburnedGoals: Bool)] ) -> Goal {
        let strategyManager = StrategyManager(manager: self.manager)
        let strategy = try! strategyManager.assertValidActiveStrategy()
        for info in goals {
            let _ = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: info.name, backburnedGoals: info.backburnedGoals))
        }
        return strategy
    }
    
    
    /// test all goals
    func testAllGoals() {
        // setup 2 user goals and one implicit today goal
        let strategy = createStrategyWithUserGoals(goals: [(name: "Goal 1", backburnedGoals: false), (name: "Goal 2", backburnedGoals: false)])
        
        // act
        let goals = strategy.allGoals()
        
        // tests
        XCTAssertEqual(3, goals.count, "2 user goals + 1 Today Goal")
    }
    
    /// test all goals but I want only the today goal back
    func testAllGoalsWithToday() {
        // setup 2 user goals and one implicit today goal
        let strategy = createStrategyWithUserGoals(goals: [(name: "Goal 1", backburnedGoals: false), (name: "Goal 2", backburnedGoals: false)])

        // act
        let goals = strategy.allGoals(withTypes: [GoalType.todayGoal])
        
        // tests
        XCTAssertEqual(1, goals.count, "1 Today Goal")
        XCTAssertEqual(GoalType.todayGoal, goals[0].goalType())
    }
    
    func testAllGoalsBackburned() {
        // setup 2 user goals and one implicit today goal
        let strategy = createStrategyWithUserGoals(goals: [(name: "Goal 1", backburnedGoals: false), (name: "Goal 2", backburnedGoals: true)])
        
        // act
        let goals = strategy.allGoalsByPrio(withBackburned: false)
        
        // tests
        XCTAssertEqual(2, goals.count, "1 user Goal which isn't backburnedGoals: and today goals")
        XCTAssertEqual("Goal 1", goals[1].name)

    }
}
