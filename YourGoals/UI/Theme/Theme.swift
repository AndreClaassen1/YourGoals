//
//  Theme.swift
//  YourGoals
//
//  Created by André Claaßen on 16.08.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

/// a class which represents the most important colors of the UI
public class Theme {
    public let gray = UIColor.gray
    
    public var progressText:UIColor {
        return gray
    }
    
    public static let defaultTheme = Theme()
}


