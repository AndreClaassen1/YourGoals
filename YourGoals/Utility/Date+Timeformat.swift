//
//  Date+Timeformat.swift
//  YourGoals
//
//  Created by André Claaßen on 08.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

extension Date {
    
    /// - Returns: a string representation of the time without the date
    public func formattedTime() -> String {
        return DateFormatter.createShortTimeFormatter().string(from: self)
    }
}
