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

protocol FormItem {
}

//protocol TypedFormItem:FormItem {
//    associatedtype FormItemType
//
//    var value:FormItemType { get }
//    var options:[FormItemType] { get }
//}

class TypedFormItem<T>:FormItem {
    let value:T
    let options:[T]
    
    init(_ value:T) {
        self.value = value
        self.options = []
    }
    
    init(value:T, options:[T]) {
        self.value = value
        self.options = options
    }
    
}


/// a value for the form field
class  TextFormItem : TypedFormItem<String> {
}

class OptionFormItem<T>:TypedFormItem<T> {
    let valueToText:(T) -> String
    
    init(value: T, options:[T], valueToText:@escaping (T) -> String) {
        self.valueToText = valueToText
        super.init(value: value, options: options)
    }
}

/// this class return all form value entries for the the edit task form object
class EditTaskForm {
    var formItems:[EditTaskFormTag: FormItem] = [:]
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
    public subscript<T>(tag: EditTaskFormTag) -> TypedFormItem<T>? {
        guard let item = self.formItems[tag] else {
            NSLog("the tag \(tag) isn't available for this form")
            assertionFailure()
            return nil
        }
        
        guard let typedItem = item as? TypedFormItem<T> else {
            assertionFailure("couldn't convert item for tag \(tag) to typedItem of type \(T.self)")
            return nil
        }

        return typedItem
    }
    
    public subscript<T>(tag: String?) -> TypedFormItem<T>? {
        guard let tag = tag else {
            assertionFailure("tag isn't available")
            return nil
        }
        
        guard let editTaskFormTag = EditTaskFormTag(rawValue: tag) else {
            assertionFailure("tag \(tag) isn't a valid edittaskformtag")
            return nil
        }
        
        
        return self[editTaskFormTag]
    }

    /// configure the various form item object needed for the EditTaskForm
    ///
    /// - Throws: a core data exception
    func configure() throws {
        formItems[EditTaskFormTag.taskTag] = TextFormItem(actionable?.name ?? "")
        formItems[EditTaskFormTag.goalTag] = OptionFormItem<Goal>(value: goal, options: try selectableGoals(), valueToText: { $0.name ?? "no goal name" })
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
