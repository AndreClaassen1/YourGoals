//
//  TaskProgress+statea.swift
//  YourGoals
//
//  Created by André Claaßen on 01.07.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation

/// a calculated state of the task progress
///
/// - progressing: the progress is progressing (active)
/// - done: the progress is finished
enum TaskProgressState {
    case progressing
    case done
}

extension TaskProgress {
    /// returns the state of the progress. if the end is open, then this progress is progressing and not finished yed
    var state:TaskProgressState {
        if end == nil {
            return .progressing
        }
        return .done
    }
}
