//
//  TestDataCreator.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

/// this class makes the creation of goals and tasks a little bit easier
class TestDataCreator:StorageManagerWorker {
    
    /// create a goal for unit testing
    ///
    /// - Parameter name: name of the goal
    /// - Returns: the goal
    func createGoal(name: String, prio: Int16 = 1, backburned: Bool = false) -> Goal {
        let strategyManager = StrategyManager(manager: self.manager)
        let goal = try! strategyManager.createNewGoalForStrategy(goalInfo: GoalInfo(name: name, reason: "test reasons", startDate: Date.minimalDate, targetDate: Date.maximalDate, prio: prio, backburned: backburned))
        return goal
    }
    
    /// generate valid test data with goals and tasks. you can specifiy, if a goal is backburned or not
    ///
    /// - Parameters:
    ///   - date: date for committed tasks
    ///   - data: testsdata with tuples of goalnames, backburned indicator and number of tasks for the goal
    func generateTestData(startDate date: Date, data: [(goalName:String, backburned: Bool, numberOfTasks: Int)]) {
        for d in data {
            let goal = self.createGoal(name: d.goalName, backburned: d.backburned)
            for i in 0 ..< d.numberOfTasks {
                let task = self.createTask(name: "Task #\(i) for Goal \(d.goalName)", forGoal: goal)
                task.commitmentDate = date
            }
        }
        
        try! self.manager.saveContext()
    }

    
    /// create a task for unit testing for the given goal with the name
    ///
    /// - Parameters:
    ///   - name: name of the task
    ///   - goal: the goal
    /// - Returns: a new  task
    @discardableResult
    func createTask(name: String, withSize size: Float = 30.0, andPrio prio:Int? = nil, commitmentDate:Date? = nil, forGoal goal: Goal) -> Task {
        let composer = GoalComposer(manager: self.manager)
        let task = try! composer.create(actionableInfo: ActionableInfo(type: .task, name: name, commitDate: commitmentDate, size: size), toGoal: goal) as! Task
        if let prio = prio {
            task.prio = Int16(prio)
        }
        try! self.manager.saveContext()
        
        return task
    }
    
    /// create a range of tasks and a goal
    ///
    /// - Parameter infos: infos for the tassk
    /// - Returns: goal
    func createGoalWithTasks(infos: [(name: String, prio:Int, size:Float, commitmentDate: Date? )]) -> Goal {
       
        let goal = self.createGoal(name: "New Unit-Test Goal")
        
        for info in infos {
            createTask(name: info.name, withSize: info.size, andPrio: info.prio, commitmentDate: info.commitmentDate, forGoal: goal)
        }
        
        return goal
    }
    
    func startProgress(forTask task: Task, atDate date: Date) {
        let progressManager = TaskProgressManager(manager: self.manager)
        try! progressManager.startProgress(forTask:task, atDate: date)
    }
    
    @discardableResult
    func createProgress(forTask task: Task, start: Date, end: Date) -> TaskProgress {
        let taskProgress = self.manager.taskProgressStore.createPersistentObject()
        taskProgress.start = Date.dateWithYear(2017, month: 01, day: 01)
        taskProgress.end = Date.dateWithYear(2017, month: 05, day: 19)
        task.addToProgress(taskProgress)
        try! self.manager.saveContext()
        return taskProgress
    }
}
