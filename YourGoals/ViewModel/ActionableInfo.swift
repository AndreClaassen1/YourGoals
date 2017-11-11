//
//  ActionableInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// a view model representation an actionable (task or habit)
struct ActionableInfo {
    let name:String
    
    /// initialize the actionable with the needed values
    ///
    /// - Parameter name: the name of the actionable
    init(name:String){
        assert(!name.isEmpty)
        self.name = name
    }
}
