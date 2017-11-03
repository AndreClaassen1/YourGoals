//
//  ManagerWorker.swift
//  YourGoals
//
//  Created by André Claaßen on 28.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

protocol GoalsModelManipulator {
    func setModelUpdateDelegate(delegate: GoalsModelUpdateDelegate)
}

class StorageManagerWorker:GoalsModelManipulator {
    let manager:GoalsStorageManager
    
    /// a core data storage manager class
    init (manager:GoalsStorageManager) {
        self.manager = manager
    }
    
    // MARK: - GoalsModelManipulator
    
    var updateDelegate:GoalsModelUpdateDelegate?
    
    func setModelUpdateDelegate(delegate: GoalsModelUpdateDelegate) {
        self.updateDelegate = delegate
    }
}
