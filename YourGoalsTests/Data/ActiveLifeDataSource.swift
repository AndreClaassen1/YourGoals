//
//  ActiveLifeDataSource.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 22.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
import XCTest
@testable import YourGoals

class ActiveLifeDataSourceTests: StorageTestCase {
    
    typealias TestTaskEntry = (task:String, size:String, State:String, Begin:String?)
    
    /// given a day with
    ///
    /// Example:
    ///
    ///     Task                     | Size | State  | Begin  |
    ///     -------------------------+------+--------+--------+
    ///     This is the first Task   | 30m  | Active |        |
    ///     This is the second Task  | 15m  | Active |        |
    ///     This is the third  Task  | 30m  | Done   | 08:00  |
    ///
    /// when
    ///     I calc this like active life from 08:00 the day
    ///
    /// then I expect
    ///     the following time table
    ///
    ///     Begin  | Task                     | Remaining | State  |
    ///     -------+--------------------------+-----------+--------+
    ///      08:00 | This is the third  Task  |       0m  | Done   |
    ///      08:30 | This is the first Task   |      30m  | Active |
    ///      08:45 | This is the second Task  |      15m  | Active |

    func testGiven3SimpleTasksWithOneDone() {
    
        // setup
        
        let testData:[TestTaskEntry] = [
            ("This is the first Task", "30m", "Active", nil),
            ("This is the second Task", "15m", "Active", nil),
            ("This is the third Task", "30m", "Done", nil)
        ]
        
        // act
        
        // test
        
    }
}
