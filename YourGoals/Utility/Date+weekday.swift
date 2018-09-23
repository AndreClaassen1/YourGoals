//
//  date+weekday.swift
//  YourGoals
//
//  Created by André Claaßen on 23.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

extension Date {
    
    /// get day of the week
    func  weekday() -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday
    }
}
