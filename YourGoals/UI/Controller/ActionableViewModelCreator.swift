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
/// **Hint**: A tag is a unique field identifier
///
/// - titleTag: the tag for the title in the navigation bar of the form
/// - taskTag: the tag id of the task
/// - goalTag: the tag id of the selectable goal
/// - commitDateTag: the task id of the commit date
enum EditTaskFormTag:String  {
    case titleTag
    case taskTag
    case goalTag
    case commitDateTag
}

/// this class creates a view model for a new/existing task or habit
class ActionableViewModelCreator:StorageManagerWorker {
    
    /// create a view model for a new actionable
    ///
    /// - Parameters:
    ///   - goal: for this goal
    ///   - type: with this type (task or habit)
    ///     date: the date of the day for creating a list of commit dates
    ///
    /// - Returns: the view model
    /// - Throws: a core data exception
    func createViewModel(for goal:Goal, andType type: ActionableType, atDate date: Date) throws -> FormViewModel {
        let viewModel = FormViewModel()
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.titleTag.rawValue, value:  "New \(type.asString())"))
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.taskTag.rawValue, value:  ""))
        try self.add(goal: goal, toViewModel: viewModel)
        self.add(forType: type, commitDate: nil, startingWithDate: date, toViewModel: viewModel)
        return viewModel
    }
    
    /// create a view mode for an existing actionable
    ///
    /// - Parameters
    ///     actionable: the actionable
    ///     date: the date of the day for creating a list of commit dates
    ///
    /// - Returns: a form view model for this actionable
    /// - Throws: a core data exception
    func createViewModel(for actionable:Actionable, atDate date: Date) throws -> FormViewModel {
        let viewModel = FormViewModel()
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.titleTag.rawValue, value:  "Edit \(actionable.type.asString())"))
        viewModel.add(item: TextFormItem(tag: EditTaskFormTag.taskTag.rawValue, value:  actionable.name))
        try self.add(goal: actionable.goal!, toViewModel: viewModel)
        self.add(forType: actionable.type, commitDate: actionable.commitmentDate, startingWithDate: date, toViewModel: viewModel)
        return viewModel
    }
    
    /// add a selectable goal to the view model
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - viewModel: the view model
    /// - Throws: a core data exception
    func add(goal: Goal, toViewModel viewModel:FormViewModel) throws {
        viewModel.add(item: OptionFormItem<Goal>(tag: EditTaskFormTag.goalTag.rawValue, value: goal, options: try selectableGoals(), valueToText: { $0.name ?? "no goal name" }))
    }
    
    /// add a list of easy selectable commit dates to the view model
    ///
    /// - Parameters:
    ///   - type: selectable commit dates are only available for tassk
    ///   - commitDate: a (optional) commit date
    ///   - date: today date
    ///   - viewModel: the view model
    func add(forType type:ActionableType, commitDate: Date?, startingWithDate date:Date, toViewModel viewModel:FormViewModel)  {
        let commitDateCreator = SelectableCommitDatesCreator()
        let tuples = commitDateCreator.selectableCommitDates(startingWith: date, numberOfDays: 7, includingDate: commitDate)
        let value = commitDateCreator.dateAsTuple(date: commitDate)
        let item = OptionFormItem<CommitDateTuple>(tag: EditTaskFormTag.commitDateTag.rawValue,
                                                   value: value, options: tuples,
                                                   valueToText: { $0.text }
        )

        viewModel.add(item: item)
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

}
