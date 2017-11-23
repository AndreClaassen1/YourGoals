//
//  GoalInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

/// a view model representation of a goal
struct GoalInfo {
    let name:String
    let reason:String
    let startDate:Date
    let targetDate:Date
    let image:UIImage?
    
    /// initialize a goal info struct with defaults for easier unit testing
    ///
    /// - Parameters:
    ///   - name: name of the goal
    ///   - reason: the reason, why this goal must be existing
    ///   - startDate: start date of the goal
    ///   - targetDate: target date of the goal
    ///   - image: motivating image of the goal
    /// - Throws: an exception, if the data values are invalid
    init(name:String, reason:String? = nil, startDate:Date = Date.minimalDate, targetDate:Date = Date.maximalDate, image:UIImage? = nil) {
        
        self.name = name
        self.reason = reason ?? ""
        self.startDate = startDate
        self.targetDate = targetDate
        self.image = image
    }
}
