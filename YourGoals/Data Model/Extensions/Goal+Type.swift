//
//  Goal+Type.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

enum GoalType:Int16 {
    case userGoal = 0
    case strategyGoal = 1
    case todayGoal = 2
}

extension Goal {
    
    /// retrieve a valid goal type
    ///
    /// - Returns: .userGoal, .todayGoal or .strategyGoal
    func goalType() -> GoalType {
        if self.parentGoal == nil {
            return .strategyGoal
        }
        
        return GoalType(rawValue: self.type)!
    }
}
