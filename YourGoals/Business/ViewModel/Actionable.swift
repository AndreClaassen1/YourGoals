//
//  Actionable.swift
//  YourGoals
//
//  Created by André Claaßen on 05.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//
import Foundation

/// states
///
/// - active: the Actionable is active
/// - done: actionable is done
enum ActionableState:Int {
    case active = 0
    case done = 1
}

/// this is the type of the actionable
///
/// - task: its a task
/// - habit: its a habit
enum ActionableType {
    case task
    case habit
    
    func asString() -> String {
        switch self {
        case .task:
            return "Task"
        case .habit:
            return "Habit"
        }
    }
}

/// protocol to unify the behavior of a task or an habit for the task view
protocol Actionable {
    
    /// the type of the actionable: A habit or a task
    var type:ActionableType { get }
    
    /// name of the actionable
    var name:String? { set get }
    
    /// the associated goal for this
    var goal:Goal? { set get }
    
    var prio:Int16 { set get }
    
    /// obtain the checked state for agiven state
    ///
    /// - Parameter date: checked at a given date
    /// - Returns: the checked state for this date
    func checkedState(forDate date: Date) -> ActionableState
    
    /// get the progress in time for the given date
    func calcProgressDuration(atDate date:Date) -> TimeInterval?
    
    /// true, if task is in progressing state at date
    ///
    /// - Parameter date: date
    /// - Returns: true
    func isProgressing(atDate date: Date) -> Bool
    
    /// commitet day of the work
    var commitmentDate:Date? { set get }
    
    /// estimated size of the work in minute
    var size:Float { set get }
    
    /// get the commiting state of the work for a specific day
    ///
    /// - Parameter date: the day
    /// - Returns: the state of the work: Not committed, committed, comitted for the past
    func committingState(forDate date:Date) -> CommittingState
}
