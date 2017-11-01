//
//  TaskCommitmentTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class TaskCommitmentTests: StorageTestCase {
    
    func testNotCommitment() {
        // setup
        let testDate = Date.dateWithYear(2017, month: 11, day: 1)
        let factory = TaskFactory(manager: self.manager)
        let task = factory.create(name: "Task", state: .active, prio: 1)
        
        // act
        
        
        // done
        XCTAssertEqual(CommittingState.notCommitted, task.commitingState(forDate: testDate))
        
    }
    
}
