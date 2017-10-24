//
//  YourGoalsTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class GoalsStorageTests: StorageTestCase  {

    func testGenerateTestData() {
        let strategy = StrategyRetriever(manager: self.manager)
        let activeStrategy = strategy.activeStrategy
        XCTAssertNil(activeStrategy)
//
//
//        let noplan = try! manager.retrieveActiveFitnessPlan()
//        XCTAssertNil(noplan)
//
//        try! generator.createTestGoals()
//        let plan = try! manager.retrieveActiveFitnessPlan()
//        XCTAssertNotNil(plan)
//        XCTAssertEqual(8, plan!.planItems!.count)
    }
}
