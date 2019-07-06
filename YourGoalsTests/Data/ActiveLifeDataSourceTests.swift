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

fileprivate typealias TestTaskEntry = (task:String, size:String, progress:String, taskState:String, beginTime:String?)
fileprivate typealias TestResultTuple = (begin: String, timeState:String, task:String, remaining:String, taskState: String)

func == <TestResultTuple:Equatable>(lhs: TestResultTuple, rhs: TestResultTuple) -> Bool {
    return lhs == rhs
}

class ActiveLifeDataSourceTests: StorageTestCase {
    
    let testDate = Date.dateWithYear(2019, month: 06, day: 23)
    
    // typealias TaskInfoTuple = (name: String, prio:Int, size:Float, commitmentDate: Date?, beginTime: Date?)
    
    /// helper function to extract a size based on a string formatted like "30m"
    ///
    /// - Parameter size: a string
    /// - Returns: size in minutes
    func extractSizeInMinutes(_ size:String) -> Float? {
        let re = try! NSRegularExpression(pattern: #"(\d*) *m"#, options: NSRegularExpression.Options.init())
        guard let match = re.firstMatch(in: size, options: [], range: NSRange(location: 0, length: size.utf16.count)) else {
            return nil
        }
        
        let nsrange = match.range(at:1)
        guard let range = Range(nsrange, in: size) else {
            return nil
        }
        
        let sizeNumberStr = size[range]
        guard let sizeNumber = Float(sizeNumberStr) else {
            return nil
        }
        return sizeNumber
    }
    
    /// convert a for this test suite optimized TestTaskEntry to the TaskInfoTuple of the test data generator
    ///
    /// - Parameters:
    ///   - entry: test task entry
    ///   - commitDate: the commit date for the tasks
    ///   - prio: a prio for this entry
    /// - Returns: a perfectly TaskInfoTuple
    fileprivate func taskInfoTuple(from entry: TestTaskEntry, withCommitDate commitDate: Date, prio: Int) -> TaskInfoTuple {
        let size = extractSizeInMinutes(entry.size)!
        let progress = extractSizeInMinutes(entry.progress)
        let time:Date? = entry.beginTime == nil ? nil : DateFormatter.timeFromShortTimeFormatted(timeStr: entry.beginTime!, locale: Locale(identifier: "de-DE"))
        let state:ActionableState = entry.taskState == "Active" ? .active : .done
        
        return (name: entry.task, prio: prio, size: size, progress: progress, commitmentDate: commitDate, beginTime: time, state: state)
    }
    
    /// create the test data out of the array of test task etnries
    ///
    /// - Parameter testData: the test task entries
    fileprivate func createTestData(testData:[TestTaskEntry]) {
        let goal = self.testDataCreator.createGoal(name: "Test Goal for Active Life Data Source Tests")
        var tuples = [TaskInfoTuple]()
        var prio = 0
        for entry in testData {
            tuples.append(taskInfoTuple(from: entry, withCommitDate: self.testDate, prio: prio))
            prio += 1
        }
        self.testDataCreator.createTasks(forGoal: goal, infos: tuples)
    }
    
    /// creates a test result tuple from the starting time tuple
    ///
    /// - Parameter tuple: a actionable and a calculated starting time info for the actionable
    /// - Returns: a test result tuple
    fileprivate func testResultTuple(from timeInfo: ActionableTimeInfo) -> TestResultTuple {
        let actionable = timeInfo.actionable
        let begin = timeInfo.startingTime.formattedTime(locale: Locale(identifier: "de-DE"))
        let task = actionable.name ?? "no task name available"
        let remaining = "\(timeInfo.remainingTimeInterval.formattedInMinutesAsString(supressNullValue: false))"
        let state = timeInfo.state.asString()
        let timeState = timeInfo.conflicting ? "Conflicting" : ""
        return (begin, timeState, task, remaining, state)
    }
    
    /// generates a string with the information about the tuple
    ///
    /// - Parameters:
    ///   - index: number of test result
    ///   - expected: expected value
    ///   - actual: actual value
    /// - Returns: a string for the error output
    fileprivate func dumpResult(index:Int, expected: TestResultTuple, actual: TestResultTuple) -> String {
        
        func dumpResultTuple(_ tuple: TestResultTuple) -> String {
            return "\(tuple)"
        }

        let result =
            "Result \(index) is not as expected\n" +
            "expected: \(dumpResultTuple(expected)) \n" +
            "actual  : \(dumpResultTuple(actual))"
        return result
    }
    
    /// checks the result from the ActionableDataSource against an expected result. If there are any difference
    /// a test exception will be raised
    ///
    /// - Parameters:
    ///   - expected: expected test results
    ///   - actual: actual native results from the actionable data source
    fileprivate func checkResult(expected: [TestResultTuple], actual:[ActionableTimeInfo]) {
        let actualResults:[TestResultTuple] = actual.map { testResultTuple(from: $0) }
        XCTAssertEqual(actualResults.count, expected.count)
        for i in 0..<actualResults.count {
            XCTAssert(expected[i] == actualResults[i], dumpResult(index: i, expected: expected[i], actual: actualResults[i]))
        }
    }
    
    /// given a day with following tasks
    ///
    /// Example:
    ///
    ///     # | Task                     | Size  | State  | Begin  |
    ///     --+--------------------------+-------+--------+--------+
    ///     1 | This is the first Task   | 30 m  | Active |        |
    ///     2 | This is the second Task  | 15 m  | Active |        |
    ///     3 | This is the third Task   | 30 m  | Active |        |
    ///
    /// when
    ///     I calc this like active life from 08:00 the day
    ///
    /// then I expect
    ///     the following time table
    ///
    ///     Begin  | Task                     | Remaining  | State  |
    ///     -------+--------------------------+------------+--------+
    ///      08:00 | This is the first Task   |       0 m  | Active |
    ///      08:30 | This is the second Task  |      15 m  | Active |
    ///      08:45 | This is the third Task   |      30 m  | Active |
    func testGiven3SimpleActiveTasks() {
        
        // setup
        let testData:[TestTaskEntry] = [
            ("This is the first Task", "30 m", "", "Active", nil),
            ("This is the second Task", "15 m", "", "Active", nil),
            ("This is the third Task", "30 m", "", "Active", nil)
        ]
        self.createTestData(testData: testData)
        
        // act
        let activeLifeDataSource = ActiveLifeDataSource(manager: self.manager)
        let testTime = self.testDate.add(hours: 08, minutes: 00) // 08:00 am
        let timeInfos = try! activeLifeDataSource.fetchTimeInfos(forDate: testTime, withBackburned: false)
        
        // test
        let expectedResult = [
            ("08:00", "", "This is the first Task", "30 m", "Active"),
            ("08:30", "", "This is the second Task", "15 m", "Active"),
            ("08:45", "", "This is the third Task", "30 m", "Active")
        ]
        
        checkResult(expected: expectedResult, actual: timeInfos)
    }
    
    /// given a day with following tasks
    ///
    /// Example:
    ///
    ///     # | Task                     | Size  | State  | Begin  |
    ///     --+--------------------------+-------+--------+--------+
    ///     1 | This is the first Task   | 30 m  | Done   | 08:00  |
    ///     2 | This is the second Task  | 15 m  | Active |        |
    ///     3 | This is the third Task   | 30 m  | Active |        |
    ///
    /// when
    ///     I calc this like active life from 08:00 the day
    ///
    /// then I expect
    ///     the following time table
    ///
    ///     Begin  | Task                     | Remaining  | State  |
    ///     -------+--------------------------+------------+--------+
    ///      08:00 | This is the first Task   |       0 m  | Done   |
    ///      08:30 | This is the second Task  |      15 m  | Active |
    ///      08:45 | This is the third Task   |      30 m  | Active |
    func testGiven2ActiveAnd1DoneTasks() {
        
        // setup
        let testData:[TestTaskEntry] = [
            ("This is the first Task", "30 m", "", "Done", "08:00"),
            ("This is the second Task", "15 m", "", "Active", nil),
            ("This is the third Task", "30 m", "", "Active", nil)
        ]
        self.createTestData(testData: testData)
        
        // act
        let activeLifeDataSource = ActiveLifeDataSource(manager: self.manager)
        let testTime = self.testDate.add(hours: 08, minutes: 00) // 08:00 am
        let timeInfos = try! activeLifeDataSource.fetchTimeInfos(forDate: testTime, withBackburned: true)
        
        // test
        let expectedResult = [
            ("08:00", "", "This is the first Task", "0 m", "Done"),
            ("08:30", "", "This is the second Task", "15 m", "Active"),
            ("08:45", "", "This is the third Task", "30 m", "Active")
        ]
        
        checkResult(expected: expectedResult, actual: timeInfos)
    }

    /// given a day with following tasks
    ///
    /// Example:
    ///
    ///     # | Task                     | Size  | State  | Begin  |
    ///     --+--------------------------+-------+--------+--------+
    ///     1 | This is the first Task   | 30 m  | Active |        |
    ///     2 | This is the second Task  | 15 m  | Active | 08:15  |
    ///     3 | This is the third Task   | 30 m  | Active |        |
    ///
    /// when
    ///     I calc this like active life from 08:00 the day
    ///
    /// then I expect
    ///     the following time table (C stands for conflicting
    ///
    ///     Begin  | C | Task                     | Remaining  | State  |
    ///     -------+------------------------------+------------+--------+
    ///      08:00 |   | This is the first Task   |      30 m  | Done   |
    ///      08:15 | X | This is the second Task  |      15 m  | Active |
    ///      08:30 |   | This is the third Task   |      30 m  | Active |
    func testGivenOneConflictingTask() {
        
        // setup
        let testData:[TestTaskEntry] = [
            ("This is the first Task", "30 m", "", "Active", nil),
            ("This is the second Task", "15 m", "", "Active", "08:15"),
            ("This is the third Task", "30 m", "", "Active", nil)
        ]
        self.createTestData(testData: testData)
        
        // act
        let activeLifeDataSource = ActiveLifeDataSource(manager: self.manager)
        let testTime = self.testDate.add(hours: 08, minutes: 00) // 08:00 am
        let timeInfos = try! activeLifeDataSource.fetchTimeInfos(forDate: testTime, withBackburned: true)
        
        // test
        let expectedResult = [
            ("08:00", "", "This is the first Task", "30 m", "Active"),
            ("08:15", "Conflicting", "This is the second Task", "15 m", "Active"),
            ("08:30", "", "This is the third Task", "30 m", "Active")
        ]
        
        checkResult(expected: expectedResult, actual: timeInfos)
    }
    
    /// given a day with following tasks
    ///
    /// Example:
    ///
    ///     # | Task                     | Size  | Progress| State  | Begin  |
    ///     --+--------------------------+-------+---------+--------+--------+
    ///     1 | This is the first Task   | 30 m  |   15m   | Active |        |
    ///     2 | This is the second Task  | 30 m  |         | Active |        |
    ///
    /// when
    ///     I calc this like active life from 08:00 the day
    ///
    /// then I expect
    ///
    ///     the following time table
    ///
    ///     Begin  | C | Task                     | Remaining  | State  |
    ///     -------+------------------------------+------------+--------+
    ///      08:00 |   | This is the first Task   |       0 m  | Done   |
    ///      08:15 |   | This is the first Task   |      15 m  | Active |
    ///      08:30 |   | This is the second Task  |      30 m  | Active |
    func testGivenPartialDoneTask() {
        
        // setup
        let testData:[TestTaskEntry] = [
            ("This is the first Task", "30 m", "15 m", "Active", "08:00"),
            ("This is the second Task", "30 m", "", "Active", nil),
        ]
        self.createTestData(testData: testData)
        
        // act
        let activeLifeDataSource = ActiveLifeDataSource(manager: self.manager)
        let testTime = self.testDate.add(hours: 08, minutes: 00) // 08:00 am
        let timeInfos = try! activeLifeDataSource.fetchTimeInfos(forDate: testTime, withBackburned: true)
        
        // test
        let expectedResult = [
            ("08:00", "", "This is the first Task", "0 m", "Done"),
            ("08:15", "", "This is the first Task", "15 m", "Active"),
            ("08:30", "", "This is the second Task", "30 m", "Active")
        ]
        
        checkResult(expected: expectedResult, actual: timeInfos)
    }
}

