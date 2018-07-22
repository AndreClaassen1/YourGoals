//
//  ProtocolDataSource.swift
//  YourGoals
//
//  Created by André Claaßen on 14.06.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation


struct ProtocolGoalInfo {
    
}

struct ProtocolProgressInfo {
    
}

/// <#Description#>
class ProtocolDataSource : StorageManagerWorker {
    func fetchWorkedGoals(forDate date: Date) throws -> [ProtocolGoalInfo] {
        return []
    }
    
    func fetchProgressOnGoal(goalInfo: ProtocolGoalInfo) -> [ProtocolProgressInfo] {
        return []
    }
}
