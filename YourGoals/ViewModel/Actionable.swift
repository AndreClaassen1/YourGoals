//
//  Actionable.swift
//  YourGoals
//
//  Created by André Claaßen on 05.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//
import Foundation

/// the actionable is checked or not for a given date/time
///
/// - notChecked: the actionable isn't checked
/// - checked: it is checke
enum CheckedState {
    case notChecked
    case checked
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
    func checkedState(forDate date: Date) -> CheckedState
    
    /// get the progress in time for the given date
    func calcProgressDuration(atDate date:Date) -> TimeInterval?
}
