//
//  TaskDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// task switching behavior
class TaskSwitchProtocolProvider {
    let stateManager:ActionableSwitchProtocol
    let progressManager:ActionableSwitchProtocol
    let commitmentManager:ActionableSwitchProtocol
    
    /// init the protocol provider with the core data storage manager
    ///
    /// - Parameter manager: a storage manager
    init(manager:GoalsStorageManager) {
        self.stateManager = TaskStateManager(manager: manager)
        self.progressManager = TaskProgressManager(manager: manager)
        self.commitmentManager = TaskCommitmentManager(manager: manager)
    }
    
    /// get the task swith protocol for the desired behaviour (like, completion, starting a work or checking a habt)
    ///
    /// - Parameter behavior: the behaviour like state of the task, commitment for work or start working (progress)
    /// - Returns: an abstract switching protocol for the desired behavior
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol {
        switch behavior {
        case .commitment, .tomorrow:
            return commitmentManager
        case .progress:
            return progressManager
        case .state:
            return stateManager
        }
    }
}
