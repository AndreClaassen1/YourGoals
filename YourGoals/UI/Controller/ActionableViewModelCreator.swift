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
        try self.addGoal(goal: goal, toViewModel: viewModel)
        switch type {
        case .task:
            try self.addCommitDate(date: nil, toViewModel: viewModel)
        case .habit:
            break
        }
        
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
        try self.addGoal(goal: actionable.goal!, toViewModel: viewModel)
        return viewModel
    }
    
    /// add a selectable goal to the view model
    ///
    /// - Parameters:
    ///   - goal: the goal
    ///   - viewModel: the view model
    /// - Throws: a core data exception
    func addGoal(goal: Goal, toViewModel viewModel:FormViewModel) throws {
        viewModel.add(item: OptionFormItem<Goal>(tag: EditTaskFormTag.goalTag.rawValue, value: goal, options: try selectableGoals(), valueToText: { $0.name ?? "no goal name" }))
    }
    
    func addCommitDate(date: Date?, toViewModel viewModel:FormViewModel) throws {
        
        
        
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
