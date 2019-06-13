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

/// valid repetitions
///
/// - monday: every monday
/// - tuesday: every tuesday
/// - wednesday: every wednesday
/// - thursday: every thursday
/// - saturday: every saturday
/// - sunday: every sunday
enum ActionableRepetition:String, Encodable, Decodable {
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    case sunday = "Sun"
    
    static func values() -> [ActionableRepetition] {
        return [
            .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday
        ]
    }
    
    /// calculate the repetition value for the weekday of the date
    ///
    /// - Parameter date: the date
    /// - Returns: a repetition value for the day of the week
    static func repetitionForDate(date: Date) -> ActionableRepetition {
        let weekday = date.weekday()
        switch weekday {
        case 1:
            return .sunday
            
        case 2:
            return .monday
        case 3:
            return .tuesday
            
        case 4:
            return .wednesday
            
        case 5:
            return .thursday
            
        case 6:
            return .friday
            
        case 7:
            return .saturday
            
        default:
            fatalError("illegal weekday number \(weekday) for date \(date)")
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
    
    var urlString:String? { set get }
    
    var imageData:Data? { set get }
    
    var repetitions:Set<ActionableRepetition> { set get }
    
    /// obtain the checked state for agiven state
    ///
    /// - Parameter date: checked at a given date
    /// - Returns: the checked state for this date
    func checkedState(forDate date: Date) -> ActionableState
    
    /// get the progress in time for the given date
    func calcProgressDuration(atDate date:Date) -> TimeInterval?
    
    func calcRemainingTimeInterval(atDate date:Date) -> TimeInterval
    
    func calcRemainingPercentage(atDate date:Date) -> Double
    
    /// true, if task is in progressing state at date
    ///
    /// - Parameter date: date
    /// - Returns: true
    func isProgressing(atDate date: Date) -> Bool
    
    /// commitet day of the work
    var commitmentDate:Date? { set get }
    
    /// optional start time of a task
    var beginTime:Date? { set get }
    
    
    /// estimated size of the work in minute
    var size:Float { set get }
    
    /// get the commiting state of the work for a specific day
    ///
    /// - Parameter date: the day
    /// - Returns: the state of the work: Not committed, committed, comitted for the past
    func committingState(forDate date:Date) -> CommittingState
}
