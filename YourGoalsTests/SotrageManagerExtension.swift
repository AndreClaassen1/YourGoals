//
//  TestDataGeneratorExtension.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 21.05.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

extension GoalsStorageManager {
    static let defaultUnitTestStorageManager = GoalsStorageManager(databaseName: "TestGoals.sqlite")
}

extension TestDataGenerator {
    static let defaultUnitTestGenerator = TestDataGenerator(manager: GoalsStorageManager.defaultUnitTestStorageManager)
}
