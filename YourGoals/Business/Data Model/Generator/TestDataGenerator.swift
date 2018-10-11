//
//  TestDataGenerator.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 21.05.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

class TestDataGenerator {
    
    let manager:GoalsStorageManager!
    let generators:[GeneratorProtocol]
    
    init(manager:GoalsStorageManager) {
        self.manager = manager
        
        generators = [
            StrategyGenerator(manager: self.manager),
            TasksGenerator(manager: self.manager)
        ]
    }
    
    func generate() throws {
        try manager.deleteRepository()
        try generators.forEach{ try $0.generate() }
        try manager.saveContext()
    }
}

class TestDataInitializer:Initializer {
    func initialize(context: InitializerContext) {
        do {
            let retriever = StrategyManager(manager: context.defaultStorageManager)
            let strategy = try retriever.retrieveActiveStrategy()
            let generator = TestDataGenerator(manager: context.defaultStorageManager)
            if strategy == nil {
                try generator.generate()
            }
        }
        catch let error  {
            fatalError("couldn't create or access test data: \(error.localizedDescription)")
        }
    }
}
