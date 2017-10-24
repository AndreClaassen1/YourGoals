//
//  YourGoalsTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class GoalsGeneratorTests: StorageTestCase  {

    func testGenerateTestData() {
        // setup
        let generator = TestDataGenerator(manager: self.manager)

        // act
        try! generator.generate()
        
        // test
        let retriever = StrategyRetriever(manager: self.manager)
        let strategy = try! retriever.activeStrategy()!
        XCTAssertEqual(2, strategy.subGoals?.count)
    }
}
