//
//  Task+Actionable.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Task: Actionable {
    func checkedState(forDate date: Date) -> CheckedState {
        return .checked
    }
}
