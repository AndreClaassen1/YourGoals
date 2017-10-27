//
//  StorageTestCase.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 21.05.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation
import XCTest
@testable import YourGoals

class StorageTestCase:XCTestCase {

    var manager:GoalsStorageManager!
    var generator:TestDataGenerator!
    
    override func setUp() {
        super.setUp()
        self.manager = GoalsStorageManager.defaultUnitTestStorageManager
        try! self.manager.deleteRepository()
        self.generator = TestDataGenerator.defaultUnitTestGenerator
    }
    
    var activeStrategy:Goal {
        return try! StrategyManager(manager: self.manager).activeStrategy()!
    }
}
