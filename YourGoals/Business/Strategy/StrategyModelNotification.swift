//
//  StrategyModelNotification.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

public enum StrategyModelNotification:String {
    case taskStateChanged
    case habitCheckStateChanged
    
    /// retrieve the identifier as notification name
    public var name : Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
