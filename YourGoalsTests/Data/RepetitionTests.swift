//
//  RepetitionTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 29.07.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class RepetitionTests: StorageTestCase {
    
    // test the encoding of the actionable repetitions
    func testRepetitionValueEncoder() {
        // setup
        let repetitions:Set<ActionableRepetition> = [ .monday, .wednesday ]
        
        // act
        let repetitionValue = try! RepetitionValueEncoder().repetitionValue(fromSet: repetitions)
        
        // test
        XCTAssertEqual("[\"Wed\",\"Mon\"]", repetitionValue)
    }
    
    func testRepetitionValueDecoder() {
        // setup
        let repetitionValue = "[\"Wed\",\"Mon\"]";
        let expectedRepetitions:Set<ActionableRepetition> = [ .monday, .wednesday ]
        
        // act
        let repetitions = try! RepetitionValueDecoder().actionableRepetitions(fromRepetitionValue: repetitionValue)
        
        // test
        XCTAssertEqual(repetitions, expectedRepetitions)
    }
    
    func testRepetitionWithTask() {
        // setup
        let factory = TaskFactory(manager: self.manager)
        let actionableInfo = ActionableInfo(type: .task, name: "This is a task with repetion", commitDate: nil, parentGoal: nil, size: 3.0, repetitions: nil)
        
        factory.create(actionableInfo: actionableInfo)
        
        // act
        
        // test
        
    }
}
