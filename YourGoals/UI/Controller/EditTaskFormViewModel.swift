//
//  EditTaskFormViewModel.swift
//  YourGoals
//
//  Created by André Claaßen on 10.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// the form tags for the EditTaskForm
///
/// A tag is a unique field identifier
///
/// - taskTag: the tag id of the task
/// - goalTag: the tag id of the selectable goal
/// - commitDateTag: the task id of the commit date
enum EditTaskFormTag:String {
    case taskTag = "TaskName"
    case goalTag = "Goal"
    case commitDateTag = "Commit Date"
}

/// a value for the form field
struct EditTaskFormItem {
    let value:Any
}

/// this class return all form value entries for the the edit task form object
class EditTaskForm {
    var formItems:[EditTaskFormTag: EditTaskFormItem] = [:]
    let goal:Goal
    let actionable:Actionable?
    let manager:GoalsStorageManager
    
    /// create a edit task form mvvm object from the edit actionable parameter
    ///
    /// - Parameters:
    ///   - manager: the storage manager
    ///   - goal: the goal for the new task
    ///   - actionable: the task which is to create
    /// - Throws: an exception
    init(manager: GoalsStorageManager, goal:Goal, actionable:Actionable?) throws {
        self.manager = manager
        self.goal = goal
        self.actionable = actionable
        try configure()
    }
    
    /// access the edit task form item via the tag
    ///
    /// - Parameter tag: the task form tag (field tag)
    public subscript(tag: EditTaskFormTag) -> EditTaskFormItem {
        guard let item = self.formItems[tag] else {
            NSLog("the tag \(tag) isn't available for this form")
            assertionFailure()
            return EditTaskFormItem(value: "./.")
        }
        
        return item
    }

    /// configure the various form item object needed for the EditTaskForm
    ///
    /// - Throws: a core data exception
    func configure() throws {
        formItems[EditTaskFormTag.taskTag] = EditTaskFormItem(value: actionable?.name ?? "")
        formItems[EditTaskFormTag.goalTag] = EditTaskFormItem(value: try selectableGoals())
    }
    
    /// an array of selectable goals
    ///
    /// - Returns: the array
    /// - Throws: a core data exception
    func selectableGoals() throws -> [Goal] {
        let strategyOrderManager = StrategyOrderManager(manager: self.manager)
        let goals = try strategyOrderManager.goalsByPrio(withTypes: [GoalType.userGoal] )
        return goals
    }
}
