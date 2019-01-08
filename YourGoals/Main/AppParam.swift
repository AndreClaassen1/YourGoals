//
//  AppParam.swift
//  YourGoals
//
//  Created by André Claaßen on 08.01.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation

//
//  AppParam.swift
//  YourDay
//
//  Created by André Claaßen on 27.03.16.
//  Copyright © 2016 Andre Claaßen. All rights reserved.
//

import Foundation
import CoreLocation

/// helper class for making the app param values visible for the whole app.
class AppParam {
    
    static let defaultParam:AppParam = AppParam()
    
    /// true, if this app runs under a ui test
    let inUiTest:Bool
    
    /// true, if this app runs under unit tests
    let inXCTest:Bool
    
    /// initialize the state with the app parameters and
    ///
    /// - Parameters:
    ///   - args: parameter values
    ///   - environment: environment settings
    init(args:[String], environment: [String: String]) {
        self.inUiTest = args.any({$0 == "-ui_testing"})
        if let injectBundle = environment["XCInjectBundle"]  {
            inXCTest = (injectBundle as NSString).pathExtension == "xctest"
        }
        else {
            inXCTest = false
        }
    }
    
    convenience init() {
        self.init(args: CommandLine.arguments, environment: ProcessInfo.processInfo.environment)
    }
}
