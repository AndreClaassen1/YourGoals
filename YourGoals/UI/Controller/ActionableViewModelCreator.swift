//
//  EditActionableViewModel.swift
//  YourGoals
//
//  Created by André Claaßen on 16.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// the form tags for the FormViewModel
///
/// A tag is a unique field identifier
///
/// - taskTag: the tag id of the task
/// - goalTag: the tag id of the selectable goal
/// - commitDateTag: the task id of the commit date
enum EditTaskFormTag:String  {
    case titleTag
    case taskTag
    case goalTag
    case commitDateTag
}

/// a tuple representing a commit date in the future and a string representation
typealias CommitDateTuple = (text:String, date:Date?)

/// this class creates a view model for a new/existing task or habit
class ActionableViewModelCreator:StorageManagerWorker {
    
    /// create a view model for a new actionable
    ///
    /// - Parameters:
    ///   - goal: for this goal
    ///   - type: with this type (task or habit)
    /// - Returns: the view model
    /// - Throws: a core data exception
    func createViewModel(for goal:Goal, andType type: ActionableType) throws -> FormViewModel {
        let viewModel = FormViewModel()
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.titleTag.rawValue, value:  "New \(type.asString())"))
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.taskTag.rawValue, value:  ""))
        viewModel.add(item: OptionFormItem<Goal>(tag: EditTaskFormTag.goalTag.rawValue, value: goal, options: try selectableGoals(), valueToText: { $0.name ?? "no goal name" }))
        return viewModel
    }
    
    /// create a view mode for an existing actionable
    ///
    /// - Parameter actionable: the actionable
    /// - Returns: a form view model for this actionable
    /// - Throws: a core data exception
    func createViewModel(for actionable:Actionable) throws -> FormViewModel {
        let viewModel = FormViewModel()
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.titleTag.rawValue, value:  "Edit \(actionable.type.asString())"))
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.taskTag.rawValue, value:  actionable.name))
        viewModel.add(item: OptionFormItem<Goal>(tag: EditTaskFormTag.goalTag.rawValue, value: actionable.goal!, options: try selectableGoals(), valueToText: { $0.name ?? "no goal name" }))
        return viewModel
    }
    
    /// an array of selectable goals for this actionable
    ///
    /// - Returns: the array
    /// - Throws: a core data exception
    func selectableGoals() throws -> [Goal] {
        let strategyOrderManager = StrategyOrderManager(manager: self.manager)
        let goals = try strategyOrderManager.goalsByPrio(withTypes: [GoalType.userGoal] )
        return goals
    }
    
    /// create a list of commit dates for the next 7 days with a string
    /// representation of the date
    ///
    /// None (date = nil)
    /// Today
    /// Tommorrow
    /// Tuesday (12/19/2017) (for 19.12.2017
    /// Wednesday
    ///
    /// - Parameter date: start date for the list
    /// - Returns: a list of formatted dates
    func selectableCommitDates(startingWith date:Date, numberOfDays:Int) -> [CommitDateTuple] {
        
        return []
    }
}
