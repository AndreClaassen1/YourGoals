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
    /// name of the goal
    let name:String?
    
    /// reason why the goal exists
    let reason:String
    
    /// start date of the goal
    let startDate:Date?
    
    /// target date of the goal
    let targetDate:Date?
    
    /// a motivational image for the goal
    let image:UIImage?
    
    /// the prio of the goal
    let prio:Int16
    
    /// the goal is backburnedGoals:
    let backburnedGoals:Bool
    
    /// initialize a goal info struct with defaults for easier unit testing
    ///
    /// - Parameters:
    ///   - name: name of the goal
    ///   - reason: the reason, why this goal must be existing
    ///   - startDate: start date of the goal
    ///   - targetDate: target date of the goal
    ///   - image: motivating image of the goal
    ///   - prio: priority of the goal
    /// - Throws: an exception, if the data values are invalid
    init(name:String? = nil, reason:String? = nil, startDate:Date? = nil, targetDate:Date? = nil, image:UIImage? = nil, prio:Int16 = 999, backburnedGoals:Bool = false) {
        self.name = name
        self.reason = reason ?? ""
        self.startDate = startDate
        self.targetDate = targetDate
        self.image = image
        self.prio = prio
        self.backburnedGoals = backburnedGoals
    }
    
    /// initialize the struct with data from an existing goal
    ///
    /// - Parameter goal: the gaol
    init(goal: Goal) {
        self.name = goal.name
        self.reason = goal.reason ?? ""
        if let data = goal.imageData?.data {
            self.image = UIImage(data: data)
        } else {
            self.image = nil
        }
        self.startDate = goal.startDate
        self.targetDate = goal.targetDate
        self.prio = goal.prio
        self.backburnedGoals = goal.backburnedGoals
    }
}
