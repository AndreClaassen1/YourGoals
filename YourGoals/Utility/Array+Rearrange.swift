//
//  Array+Rearrange.swift
//  YourGoals
//
//  Created by André Claaßen on 29.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        precondition(indices.contains(from) && indices.contains(to), "invalid indexes")
        guard from != to else {
            return
        }
        insert(remove(at: from), at: to)
    }
}
