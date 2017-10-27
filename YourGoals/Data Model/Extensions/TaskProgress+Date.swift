//
//  TaskProgress+Date.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension TaskProgress {
    
    /// true, if the date lies between start and end of the current progress
    ///
    /// - Parameter date: check this date
    /// - Returns: true, if the date intersects the current progress
    func isIntersecting(withDate date: Date) -> Bool {
        
        let startDate = self.start ?? Date.minimalDate
        let endDate = self.end ?? Date.maximalDate
        
        return startDate.compare(date) == ComparisonResult.orderedSame || startDate.compare(date) == ComparisonResult.orderedAscending &&
            endDate.compare(date) == ComparisonResult.orderedSame || endDate.compare(date) == ComparisonResult.orderedDescending
    }
}
