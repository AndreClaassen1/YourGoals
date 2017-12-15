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

class FormItem {
    var tag:EditTaskFormTag
    
    init(tag:EditTaskFormTag) {
        self.tag = tag
    }
}

class TypedFormItem<T>:FormItem {
    let value:T
    let options:[T]
    
    init(tag:EditTaskFormTag, value:T) {
        self.value = value
        self.options = []
        super.init(tag: tag)
    }
    
    init(tag:EditTaskFormTag, value:T, options:[T]) {
        self.value = value
        self.options = options
        super.init(tag: tag)
    }
}


/// a value for the form field
class  TextFormItem : TypedFormItem<String?> {
}

class OptionFormItem<T>:TypedFormItem<T> {
    let valueToText:(T) -> String
    
    init(tag: EditTaskFormTag, value: T, options:[T], valueToText:@escaping (T) -> String) {
        self.valueToText = valueToText
        super.init(tag: tag, value: value, options: options)
    }
}

/// this class return all form value entries for the the edit task form object
class EditTaskForm {
    var formItems = [FormItem]()
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
    
    public func item<T>(tag: EditTaskFormTag) -> TypedFormItem<T> {
        guard let item = self.formItems.first(where: {$0.tag == tag}) else {
            fatalError("the tag \(tag) isn't available for this form")
        }
        
        guard let typedItem = item as? TypedFormItem<T> else {
            fatalError("item with type \(T.self) is for \(tag) not available")
        }
        
        return typedItem
    }
    
    /// get an typed form item out of the view model. this is method is optimized for row types for Eureka
    ///
    /// - Parameter tag: the tag
    /// - Returns: a typed form item
    public func item<T>(tag: String?) -> TypedFormItem<T> {
        guard let tag = tag else {
            fatalError("tag isn't available")
        }
        
        guard let editTaskFormTag = EditTaskFormTag(rawValue: tag) else {
            fatalError("couldn't convert tag \(tag) to EditTaskFormTag")
        }
    
        let typedItem = item(tag: editTaskFormTag) as TypedFormItem<T>
        
        return typedItem
    }
    
    /// configure the view model with various form item object needed for the EditTaskForm
    ///
    /// - Throws: a core data exception
    func configure() throws {
        formItems.append(TextFormItem(tag: .taskTag, value: actionable?.name ?? ""))
        formItems.append(OptionFormItem<Goal>(tag: .goalTag, value: goal, options: try selectableGoals(), valueToText: { $0.name ?? "no goal name" }))
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
