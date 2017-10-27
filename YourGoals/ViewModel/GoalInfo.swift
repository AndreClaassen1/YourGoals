//
//  GoalInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

enum GoalInfoError : Error {
    case invalidGoalNameError
}

/// a view model representation of a goal
struct GoalInfo {
    let name:String
    let reason:String
    let targetDate:Date
    let image:UIImage?
    
    init(name:String, reason:String?, targetDate:Date, image:UIImage?) throws {
        guard !name.isEmpty else {
            throw GoalInfoError.invalidGoalNameError
        }
        
        self.name = name
        self.reason = reason ?? ""
        self.targetDate = targetDate
        self.image = image
    }
}
