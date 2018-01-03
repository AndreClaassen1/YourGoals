//
//  TimeInterval+Format.swift
//  YourGoals
//
//  Created by André Claaßen on 03.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

extension TimeInterval {

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

