//
//  TestDataCreator.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
@testable import YourGoals

typealias TaskInfoTuple = (name: String, prio:Int, size:Float, commitmentDate: Date?, beginTime: Date?)

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
    
    /// create a task for unit testing for the given goal with the name. the date is already saved in the
    /// core data storage
    ///
    /// - Parameters:
    ///   - name: name of the task
    ///   - size: size in minutes. Default is 30 minutes
    ///   - prio: the priority of the task
    ///   - commitmentDate: the commitment date or nil
    ///   - goal: the goal, for which the task is created for
    /// - Returns: the task
    @discardableResult
    func createTask(name: String, withSize size: Float = 30.0, andPrio prio:Int? = nil, commitmentDate:Date? = nil, beginTime: Date? = nil, forGoal goal: Goal) -> Task {
        let composer = GoalComposer(manager: self.manager)
        let task = try! composer.create(actionableInfo: ActionableInfo(type: .task, name: name, commitDate: commitmentDate, beginTime: beginTime, size: size), toGoal: goal) as! Task
        if let prio = prio {
            task.prio = Int16(prio)
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
            createTask(name: info.name, withSize: info.size, andPrio: info.prio, commitmentDate: info.commitmentDate, beginTime: info.beginTime, forGoal: goal)
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
