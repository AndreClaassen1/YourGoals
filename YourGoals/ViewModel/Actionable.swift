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

/// this is important for drawing the checkbox
///
/// - task: its a task
/// - habit: its a habit
enum ActionableType {
    case task
    case habit
}

/// protocol to unify the behavior of a task or an habit for the task view
protocol Actionable {
    
    /// name of the actionable
    var name:String? { get }
    
    /// the associated goal for this
    var goal:Goal? { get }
    
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
    
    var commitmentDate:Date? { get }
    
    func committingState(forDate date:Date) -> CommittingState


}
