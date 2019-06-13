//
//  StartingTimeHelper.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 13.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

extension StartingTimeInfo {
    init(hour:Int, minute: Int, second: Int, inDanger: Bool) {
        let time = Date.timeWith(hour: hour, minute: minute, second: second)
        let inDanger = inDanger
        self.init(start: time, remainingTimeInterval: 0, inDanger: inDanger)
    }
}

