//
//  Date+time.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.07.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

extension Date {
    /// create a time from a string representation e.g. 08:00
    ///
    /// - Parameters:
    ///   - string: the string
    ///   - locale: an optional locale. in unit tests I use germany. sorry.
    /// - Returns: a time
    static func time(fromString string:String, locale: Locale? = nil) -> Date {
        let locale = locale ?? Locale(identifier: "de-DE")
        return DateFormatter.timeFromShortTimeFormatted(timeStr: string, locale: locale)!
    }
}
