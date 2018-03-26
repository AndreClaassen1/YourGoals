//
//  ActionableFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 11.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// protocol for the Task- and HabitFactory to create a reasonable task or habit out of an actionableinfo
protocol ActionableFactory {
    func create(actionableInfo: ActionableInfo) -> Actionable
}
