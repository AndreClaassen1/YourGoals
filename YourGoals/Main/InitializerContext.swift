//
//  InitializerContext.swift
//  YourGoals
//
//  Created by André Claaßen on 24.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

struct InitializerContext {
    let defaultStorageManager:GoalsStorageManager
}

protocol Initializer {
    func initialize(context:InitializerContext)
}



