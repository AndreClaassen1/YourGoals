//
//  ProtocolDataSourceTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 10.07.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class ProtocolDataSourceTests: StorageTestCase {
    
    var protocolDataSource:ProtocolDataSource!
    
    override func setUp() {
        super.setUp()
        self.protocolDataSource = ProtocolDataSource(manager: self.manager)
    }
    
    func createTaskWithProgress(forGoal goal:Goal, withName name:String, forDay date:Date, startProgressHour hour: Int, durationProgressInMinutes duration: Int) {
        let task = self.testDataCreator.createTask(name: name, commitmentDate: date, forGoal: goal)
        let progressStart = date.addMinutesToDate(hour * 60)
        let progressEnd = progressStart.addMinutesToDate(duration)
        self.testDataCreator.createProgress(forTask: task, start: progressStart, end: progressEnd)
    }
    
    func testDataSourceFetchedWorkedGoals() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 09, day: 25)
        let goalWorked = self.testDataCreator.createGoal(name: "Test Goal with work")
        self.createTaskWithProgress(forGoal: goalWorked, withName: "Task with Progress", forDay: referenceDate, startProgressHour: 10, durationProgressInMinutes: 60)
        
        // act
        let protocolGoalInfos = try! self.protocolDataSource.fetchWorkedGoals(forDate: referenceDate)
        
        // test
        XCTAssertEqual(1, protocolGoalInfos.count)
    }

    func testDataSourceFetchedWorkedGoalsWithoutProgress() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 09, day: 25)
        let goalWorked = self.testDataCreator.createGoal(name: "Test Goal with work")
        self.testDataCreator.createTask(name: "task without progress", forGoal: goalWorked)
        // act
        let protocolGoalInfos = try! self.protocolDataSource.fetchWorkedGoals(forDate: referenceDate)
        
        // test
        XCTAssertEqual(0, protocolGoalInfos.count)
    }
    
    func testDataSourceFetchProgressForGoal() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 09, day: 25)
        let goalWorked = self.testDataCreator.createGoal(name: "Test Goal with work")
        self.createTaskWithProgress(forGoal: goalWorked, withName: "Task with Progress", forDay: referenceDate, startProgressHour: 10, durationProgressInMinutes: 60)
        self.createTaskWithProgress(forGoal: goalWorked, withName: "Task with Progress on next day", forDay: referenceDate.addDaysToDate(1), startProgressHour: 10, durationProgressInMinutes: 60)
        let goalInfos = try! self.protocolDataSource.fetchWorkedGoals(forDate: referenceDate)

        // act
        let progressInfos = try! self.protocolDataSource.fetchProgressOnGoal(goalInfo: goalInfos.first!)
        
        // test
        XCTAssertEqual(1, progressInfos.count)
    }
    
    func testDataSourceFetchDoneTasksForGoal() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 09, day: 29)
        let goal = self.testDataCreator.createGoalWithTasks(infos: [
            (name: "Task 1", prio: 1, size: 40.0, commitmentDate: nil), // 40 minutes
            (name: "Task 2", prio: 2, size: 20.0, commitmentDate: nil), // 20 minutes
            (name: "Task 3", prio: 3, size: 40.0, commitmentDate: nil)  // 40 minutes
        ])
        
        // set the first task in a done state
        let task1 = goal.allTasks().first!
        try! TaskStateManager(manager: self.manager).setTaskState(task: task1, state: .done, atDate: referenceDate)
        
        
        // act
        let goalInfos = try! self.protocolDataSource.fetchWorkedGoals(forDate: referenceDate)
        let progressInfos = try! self.protocolDataSource.fetchProgressOnGoal(goalInfo: goalInfos.first!)

        // test
        XCTAssertEqual(1, progressInfos.count)
    }
    
    
}
