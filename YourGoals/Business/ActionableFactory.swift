//
//  ActionableFactory.swift
//  YourGoals
//
//  Created by André Claaßen on 11.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

protocol ActionableFactory {
    func create(actionableInfo: ActionableInfo) -> Actionable
}
