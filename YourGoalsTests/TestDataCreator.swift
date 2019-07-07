//
//  TestDataCreator.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals
import XCTest

typealias TaskInfoTuple = (name: String, prio:Int, size:Float,  progress: Float?, commitmentDate: Date?, beginTime: Date?, state: ActionableState?)

/// this class makes the creation of goals and tasks a little bit easier
class TestDataCreator:StorageManagerWorker {
    
    /// create a goal for unit testing
    ///
    /// - Parameter name: name of the goal
    /// - Returns: the goal
    func createGoal(name: String, prio: Int16 = 1, backburnedGoals: Bool = false) -> Goal {
        let strategyManager = StrategyManager(manager: self.manager)
        let goal = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: name, reason: "test reasons", startDate: Date.minimalDate, targetDate: Date.maximalDate, prio: prio, backburnedGoals: backburnedGoals))
        return goal
    }
    
    /// generate valid test data with goals and tasks. you can specifiy, if a goal is backburnedGoals: or not
    ///
    /// - Parameters:
    ///   - date: date for committed tasks
    ///   - data: testsdata with tuples of goalnames, backburnedGoals: indicator and number of tasks for the goal
    func generateTestData(startDate date: Date, data: [(goalName:String, backburnedGoals: Bool, numberOfTasks: Int)]) {
        for d in data {
            let goal = self.createGoal(name: d.goalName, backburnedGoals: d.backburnedGoals)
            for i in 0 ..< d.numberOfTasks {
                let task = self.createTask(name: "Task #\(i) for Goal \(d.goalName)", forGoal: goal)
                task.commitmentDate = date
            }
        }
        
        try! self.manager.saveContext()
    }

    /// hack to set a task progress,
    /// which starts at the begin time and ends after the number of minutes
    /// specified with the progres
    ///
    /// Example: You have 08:00 beginn time and a progress of size 15 Minutes
    ///          Result: 08:00:00 - 08:14:59
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - progress: size of the task progress in minutes
    ///   - commitmentDate: committed date (not time)
    ///   - beginTime: start time (without date)
    func setProgress(forTask task: Task, progress:Float, commitmentDate: Date, beginTime: Date) {
        let progressManager = TaskProgressManager(manager: self.manager)
        let startTime = commitmentDate.addingTimeInterval(beginTime.timeAsInterval())
        let endTime = startTime.addingTimeInterval(TimeInterval(progress * 60.0))
        progressManager.createProgressRecord(task: task, start: startTime, end: endTime)
    }
    
    /// hack to set a done state for a task and a task progress,
    /// which starts at the begin time and ends after the size of the task
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - size: size of the task in minutes
    ///   - commitmentDate: committed date (not time)
    ///   - beginTime: start time (without date)
    func setDoneState(forTask task: Task, size:Float, commitmentDate: Date, beginTime: Date) {
        task.setTaskState(state: .done)
        setProgress(forTask: task, progress: size, commitmentDate: commitmentDate, beginTime: beginTime)
    }
    
    /// create a task for unit testing for the given goal with the name. the date is already saved in the
    /// core data storage
    ///
    /// - Parameters:
    ///   - name: name of the task
    ///   - size: size in minutes. Default is 30 minutes
    ///   - progress: an optional progress of this task in Minutes.
    ///   - prio: the priority of the task
    ///   - commitmentDate: the commitment date or nil
    ///   - goal: the goal, for which the task is created for
    /// - Returns: the task
    @discardableResult
    func createTask(name: String, withSize size: Float = 30.0, andProgress progress: Float?=nil, andPrio prio:Int? = nil, commitmentDate:Date? = nil, beginTime: Date? = nil, state: ActionableState? = nil, forGoal goal: Goal) -> Task {
        let composer = GoalComposer(manager: self.manager)
        let task = try! composer.create(actionableInfo: ActionableInfo(type: .task, name: name, commitDate: commitmentDate, beginTime: beginTime, size: size), toGoal: goal) as! Task
        
        if let prio = prio {
            task.prio = Int16(prio)
        }
        
        if state == .done {
            XCTAssertNotNil(beginTime, "if you set a progress you must also set a begin time")
            XCTAssertNotNil(commitmentDate, "if you set a progress you must also set a commitment date ")
            setDoneState(forTask: task, size: size, commitmentDate: commitmentDate!, beginTime: beginTime!)
        }
        
        if let progress = progress {
            XCTAssertNotNil(beginTime, "if you set a progress you must also set a begin time")
            XCTAssertNotNil(commitmentDate, "if you set a progress you must also set a commitment date ")
            setProgress(forTask: task, progress: progress, commitmentDate: commitmentDate!, beginTime: beginTime!)
            // begin time is for progress, not for task. :hack:
            task.beginTime = nil
        }
        
        try! self.manager.saveContext()
        
        return task
    }
    
    /// create a bunch of tasks for a given goal
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - infos: infos for the tasks
    func createTasks(forGoal goal: Goal, infos: [TaskInfoTuple] ) {
        for info in infos {
            createTask(name: info.name, withSize: info.size, andProgress: info.progress, andPrio: info.prio, commitmentDate: info.commitmentDate,
                       beginTime: info.beginTime, state: info.state, forGoal: goal)
        }
    }
    
    /// create a range of tasks and a goal and save them in the storage
    ///
    /// - Parameter infos: infos for the tassk
    /// - Returns: goal
    func createGoalWithTasks(infos: [TaskInfoTuple]) -> Goal {
        let goal = self.createGoal(name: "New Unit-Test Goal")
        createTasks(forGoal: goal, infos: infos)
        return goal
    }
    
    func startProgress(forTask task: Task, atDate date: Date) {
        let progressManager = TaskProgressManager(manager: self.manager)
        try! progressManager.startProgress(forTask:task, atDate: date)
    }
    
    @discardableResult
    func createProgress(forTask task: Task, start: Date, end: Date) -> TaskProgress {
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        taskProgress.start = start
        taskProgress.end = end
        task.addToProgress(taskProgress)
        try! self.manager.saveContext()
        return taskProgress
    }
    
    /// helper function to add a time in a string representation to a date
    ///
    /// - Parameters:
    ///   - day: the day
    ///   - startTime: the start time
    /// - Returns: the computed date time
    fileprivate func computeDateTime(_ day: Date, _ startTime: String) -> Date {
        return day.day().addingTimeInterval(Date.time(fromString: startTime).timeAsInterval())
    }
    
    @discardableResult
    /// create quick a progress for a day with start and end time as strings
    ///
    /// - Parameters:
    ///   - task: the task
    ///   - day: the day
    ///   - startTime: start time as string. eg. 18:00
    ///   - endTime: end time as string. eg. 20:00
    /// - Returns: a progress
    func createProgress(forTask task: Task, forDay day:Date? = nil, startTime: String, endTime: String) -> TaskProgress {
        let day = day ?? Date.dateWithYear(2019, month: 07, day: 01)
        let start = computeDateTime(day, startTime)
        let end = computeDateTime(day, endTime)
        return createProgress(forTask: task, start: start, end: end  )
    }

    // MARK: - Habits
    
    /// create a new test habit for a goal
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - name: the name of the habit
    /// - Returns: the new habit
    func createHabit(forGoal goal: Goal, name: String) -> Habit {
        let habit = HabitFactory(manager: self.manager).createHabit(name: name)
        goal.add(actionable: habit)
        try! self.manager.saveContext()
        return habit
    }
    
    /// check a habit for a given date and save it to the core data storage
    ///
    /// - Parameters:
    ///   - habit: the habit
    ///   - date: date to check in 
    func check(habit: Habit, forDate date: Date) {
        try! HabitCheckManager(manager: self.manager).checkHabit(forHabit: habit, state: .checked , atDate: date)
    }
}
