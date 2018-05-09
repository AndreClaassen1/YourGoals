//
//  Settings.swift
//  YourGoals
//
//  Created by André Claaßen on 04.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

protocol Settings {
    
    /// enable new untested functionality
    var newFunctions:Bool { get set }
    
    
    /// show backburned goals
    var backburnedGoals:Bool { get set }
}

class SettingsUserDefault:Settings {
    
    static var standard:Settings = SettingsUserDefault()
    
    var newFunctions: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "SettingNewFunction")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SettingNewFunction")
        }
    }
    
    /// show backburned goals
    var backburnedGoals: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "SettingBackburnedGoals")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SettingBackburnedGoals")
        }
    }
}
