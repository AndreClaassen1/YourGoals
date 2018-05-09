//
//  ActionableDataSourceProvider.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//
import Foundation

/// types of data sources
///
/// - tasks: a data source for tasks
/// - habits: a data source for habits
/// - allActionables: a data source for all actionables combined (tasks and habits
enum DataSourceType {
    case tasks
    case habits
    case allActionables
 
    /// convenience initializer for converting an actionable type (habit or task or nil) to an Data Source Type
    ///
    /// - Parameter type: Actionablbe or nil
    init(type: ActionableType?) {
        guard let type = type else {
            self = .allActionables
            return
        }
        
        switch type {
        case .task:
            self = .tasks
        case .habit:
            self = .habits
        }
    }
}

/// Provides an appropriate Data Source for the differnt views
class ActionableDataSourceProvider:StorageManagerWorker {
    
    /// retrieve the approriate data source for the type of the goal and the type wanted types of the actionables
    ///
    /// - Parameters:
    ///   - goal: goal like user goal, strategy goal or today goal
    ///   - type: type like habit or task or nil for all type
    /// - Returns: a appropriate data source
    func dataSource(forGoal goal: Goal, andType type:ActionableType?, withBackburned backburned: Bool) -> ActionableDataSource {
        let dataSourceType = DataSourceType(type: type)
        switch goal.goalType() {
        case .todayGoal:
            switch dataSourceType {
            case .habits:
                return HabitsDataSource(manager: self.manager, backburned: backburned)
            case .tasks:
                return CommittedTasksDataSource(manager: self.manager, backburned: backburned)
                
            case .allActionables:
                return TodayAllActionablesDataSource(manager: self.manager, backburned: backburned)
            }
            
        case .strategyGoal:
            fatalError("This method shouldn't be used with the strategy goal")
            
        case .userGoal:
            switch dataSourceType {
            case .habits:
                return HabitsDataSource(manager: manager, forGoal: goal, backburned: backburned)
            case .tasks:
                return GoalTasksDataSource(manager: manager, forGoal: goal)
            case .allActionables:
                assertionFailure(".all isn't supported for user goals")
                return GoalTasksDataSource(manager: manager, forGoal: goal)
            }
        }
    }
}
