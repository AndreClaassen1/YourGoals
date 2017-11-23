//
//  ManagerWorker.swift
//  YourGoals
//
//  Created by André Claaßen on 28.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// base for a business class, which does core data manipulations
class StorageManagerWorker {
    let manager:GoalsStorageManager
    
    /// a core data storage manager class
    init (manager:GoalsStorageManager) {
        self.manager = manager
    }
}
