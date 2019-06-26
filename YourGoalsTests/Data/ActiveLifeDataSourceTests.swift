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
    
    let testDate = Date.dateWithYear(2019, month: 06, day: 23)
    
    typealias TestTaskEntry = (task:String, size:String, taskState:String, beginTime:String?)
    typealias TestResultTuple = (begin: String, task:String, remaining:String, taskState: String)
    
    // typealias TaskInfoTuple = (name: String, prio:Int, size:Float, commitmentDate: Date?, beginTime: Date?)

    /// helper function to extract a size based on a string formatted like "30m"
    ///
    /// - Parameter size: a string
    /// - Returns: size in minutes
    func extractSizeInMinutes(_ size:String) -> Float {
        let re = try! NSRegularExpression(pattern: #"(\d*)m"#, options: NSRegularExpression.Options.init())
        let match = re.firstMatch(in: size, options: [], range: NSRange(location: 0, length: size.utf16.count))!
        let range = match.range(at:1)
        let sizeNumberStr = size[Range(range, in: size)!]
        let sizeNumber = Float(sizeNumberStr)!
        return sizeNumber
    }
    
    /// convert a for this test suite optimized TestTaskEntry to the TaskInfoTuple of the test data generator
    ///
    /// - Parameters:
    ///   - entry: test task entry
    ///   - commitDate: the commit date for the tasks
    ///   - prio: a prio for this entry
    /// - Returns: a perfectly TaskInfoTuple
    func taskInfoTuple(from entry: TestTaskEntry, withCommitDate commitDate: Date, prio: Int) -> TaskInfoTuple {
        let size = extractSizeInMinutes(entry.size)
        let time:Date? = entry.beginTime == nil ? nil : DateFormatter.timeFromShortTimeFormatted(timeStr: entry.beginTime!, locale: Locale(identifier: "de-DE"))
        let state:ActionableState = entry.taskState == "Active" ? .active : .done
    
        return (name: entry.task, prio: prio, size: size, commitmentDate: commitDate, beginTime: time, state: state)
    }
    
    /// create the test data out of the array of test task etnries
    ///
    /// - Parameter testData: the test task entries
    func createTestData(testData:[TestTaskEntry]) {
        let goal = self.testDataCreator.createGoal(name: "Test Goal for Active Life Data Source Tests")
        var tuples = [TaskInfoTuple]()
        var prio = 0
        for entry in testData {
            tuples.append(taskInfoTuple(from: entry, withCommitDate: self.testDate, prio: prio))
            prio += 1
        }
        self.testDataCreator.createTasks(forGoal: goal, infos: tuples)
    }
    
    /// checks the result from the ActionableDataSource against an expected result. If there are any difference
    /// a test exception will be raised
    ///
    /// - Parameters:
    ///   - expected: expected test results
    ///   - actual: actual native results from the actionable data source
    func checkResult(expected: [TestResultTuple], actual:[(Actionable, StartingTimeInfo?)]) {
        
    }

    /// given a day with following tasks
    ///
    /// Example:
    ///
    ///     # | Task                     | Size | State  | Begin  |
    ///     --+--------------------------+------+--------+--------+
    ///     1 | This is the first Task   | 30m  | Active |        |
    ///     2 | This is the second Task  | 15m  | Active |        |
    ///     3 | This is the third  Task  | 30m  | Done   | 08:00  |
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
            ("This is the third Task", "30m", "Done", "08:00")
        ]
        self.createTestData(testData: testData)
        
        // act
        let activeLifeDataSource = ActiveLifeDataSource(manager: self.manager)
        let testTime = self.testDate.add(hours: 08, minutes: 00) // 08:00 am
        let result = try! activeLifeDataSource.fetchActionables(forDate: testTime, withBackburned: true, andSection: nil)
        
        // test
        let expectedResult = [
            ("08:00", "This is the third Task", "0m", "Done"),
            ("08:30", "This is the first Task", "30m", "Active"),
            ("08:45", "This is the seond Task", "15m", "Done")
        ]
        
        checkResult(expected: expectedResult, actual: result)
    }
}
