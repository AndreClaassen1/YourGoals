//
//  YourGoalsKitTests.swift
//  YourGoalsKitTests
//
//  Created by André Claaßen on 11.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoalsKit


extension ShareStorageManager {
    /// in unit test, we are disabling write ahead mode
    static let defaultUnitTestStorageManager = ShareStorageManager(databaseName: "TestGoalsShareModel.sqlite",
                                                                   journalingEnabled: false)
}

class YourGoalsKitTests: XCTestCase {
    var manager:ShareStorageManager!
    var extensionTasksProvider:ShareExtensionTasksProvider!
    
    override func setUp() {
        self.manager = ShareStorageManager.defaultUnitTestStorageManager
        self.extensionTasksProvider = ShareExtensionTasksProvider(manager: self.manager)
    }
    
    func createNewExtensionTasks(numberOfTasks: Int) {
        for i in 0..<3 {
            try! self.extensionTasksProvider.saveNewTaskFromExtension(name: "New Task from Extension \(i)", url: nil, image: nil)
        }
    }
    
    func testShareExtensionTasksProvider() {
        // setup
        createNewExtensionTasks(numberOfTasks: 3)
        
        // act
        let tasks = try! self.manager.shareNewTaskStore.fetchAllEntries()
            
        // test
        
        XCTAssertEqual(3, tasks.count)
    }
    
    func testConsumeNewExtensionTasks() {
        // setup
        let expectation = self.expectation(description: "number of consumed tasks")
        createNewExtensionTasks(numberOfTasks: 3)
        
        // act
        var numberOfConsumedTasks = 0
        try! self.extensionTasksProvider.consumeNewTasksFromExtension { _ in
            numberOfConsumedTasks += 1
            if numberOfConsumedTasks == 3 {
                expectation.fulfill()
            }
        }
        
        // test
        self.waitForExpectations(timeout: 3.0, handler: nil)
        let tasks = try! self.manager.shareNewTaskStore.fetchAllEntries()
        XCTAssertEqual(0, tasks.count, "there should be no tasks cause all are consumed")
    }
}
