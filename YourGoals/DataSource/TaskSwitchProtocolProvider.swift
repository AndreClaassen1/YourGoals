//
//  TaskDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

class TaskSwitchProtocolProvider {
    
    let stateManager:ActionableSwitchProtocol
    let progressManager:ActionableSwitchProtocol
    let commitmentManager:ActionableSwitchProtocol
    
    init(manager:GoalsStorageManager) {
        self.stateManager = TaskStateManager(manager: manager)
        self.progressManager = TaskProgressManager(manager: manager)
        self.commitmentManager = TaskCommitmentManager(manager: manager)
    }
    
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol {
        switch behavior {
        case .commitment:
            return commitmentManager
        case .progress:
            return progressManager
        case .state:
            return stateManager
    
        }
    }
}
