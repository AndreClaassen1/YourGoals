//
//  TimeInterval+Format.swift
//  YourGoals
//
//  Created by André Claaßen on 03.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

extension TimeInterval {

    /// format the remaining time in Minutes.
    /// If the remaining time is 0 you've got an empty string
    ///
    /// - Returns: remaining time in minutes
    func formattedInMinutesAsString() -> String {
        let minutes = Int(self / 60.0)
        if minutes == 0 {
            return ""
        }
        
        return "\(minutes) m"
    }
    
    /// get a human readable string for a time interval (:ugly:)
    ///
    /// - Parameter ti: time interval
    /// - Returns: string representation in format 0:00:00
    func formattedAsString() -> String {
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let minutes = Int((self / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int(self / 3600)
        
        let result = String(format: "%d:%0.2d:%0.2d", hours, minutes, seconds)
        return result
    }

}

