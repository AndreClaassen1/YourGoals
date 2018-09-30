//
//  Array+uniqued.swift
//  YourGoals
//
//  Created by André Claaßen on 30.09.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
