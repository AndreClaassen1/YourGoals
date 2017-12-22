//
//  ActionableFormCreator.swift
//  YourGoals
//
//  Created by André Claaßen on 21.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

/// the form tags for the FormViewModel
///
/// **Hint**: A tag is a unique field identifier
///
/// - titleTag: the tag for the title in the navigation bar of the form
/// - taskTag: the tag id of the task
/// - goalTag: the tag id of the selectable goal
/// - commitDateTag: the task id of the commit date
enum EditTaskFormTag:String  {
    case taskTag
    case goalTag
    case commitDateTag
}

/// create an Eureka form for editing or creation actionables (tasks or habits)
class ActionableFormCreator:StorageManagerWorker {
    
    /// the Eureka form
    let form:Form
    
    /// initialize the form creator with the (empty) eureka form and a storage managerand
    ///
    /// - Parameters:
    ///   - form: the eureka formand
    ///   - manager: the storage manager
    init(form: Form, manager: GoalsStorageManager) {
        self.form = form
        super.init(manager: manager)
    }
    
    /// create a form based on the actionable info for the specific date
    ///
    /// ** Hint **: The date is needed to create a range of selectable commit date
    ///             textes like today, tomorrow and so on.
    ///
    /// - Parameters:
    ///   - actionableInfo: the actionable info object with all needed values
    ///   - date: the date needed to create the the commit date textes
    func createForm(for actionableInfo: ActionableInfo, atDate date: Date) {
        self.form
            +++ Section()
            <<< taskNameRow(name: actionableInfo.name)
            <<< parentGoalRow(goal: actionableInfo.parentGoal!)
            +++ Section() { $0.hidden = Condition.function([], { _ in actionableInfo.type == .habit }) }
            <<< commitDateRow(commitDate: actionableInfo.commitDate, startingDate: date)
            +++ Section()
            <<< remarksRow(remarks: nil)
    }
    
    /// create a form for editing a new actionable of the given type and for the goal.
    ///
    /// - Parameters:
    ///   - goal: new actionable for this goal
    ///   - type: new actionable with this type (a task or a habit)
    ///   - date: the date needed to create the the commit date textes
    func createForm(for goal:Goal, andType type: ActionableType, atDate date: Date) {
        let actionableInfo = ActionableInfo(type: type, name: "", commitDate: nil, parentGoal: goal)
        createForm(for: actionableInfo, atDate: date)
    }
    
    /// create a form for editing an existing actinable
    ///
    /// - Parameters:
    ///   - actionable: the actionable
    ///   - date: the date needed to create the the commit date textes
    func createForm(for actionable:Actionable, atDate date:Date) {
        let actionableInfo = ActionableInfo(actionable: actionable)
        createForm(for: actionableInfo, atDate: date)
    }
    
    // MARK: - Row creating helper functions
    
    /// create a row for editing the task name
    ///
    /// - Parameter name: the task name
    /// - Returns: a base row
    func taskNameRow(name:String?) -> BaseRow {
        let row = TextRow(tag: EditTaskFormTag.taskTag.rawValue).cellSetup { cell, row in
            cell.textField.placeholder = "Please enter your task"
            row.value = name
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesAlways
        }
        
        return row
    }
    
    /// create a row for selecting a goal
    ///
    /// - Parameter goal: the goal
    /// - Returns: the row
    func parentGoalRow(goal: Goal) -> BaseRow {
        return PushRow<Goal>(EditTaskFormTag.goalTag.rawValue) { row in
            row.title = "Select a Goal"
            row.value = goal
            row.options = selectableGoals()
            }.onPresent{ (_, to) in
                to.selectableRowCellUpdate = { cell, row in
                    cell.textLabel?.text = row.selectableValue?.name
                }
            }.cellUpdate{ (cell, row) in
                cell.textLabel?.text = "Goal"
                cell.detailTextLabel?.text = row.value?.name
        }
    }
    
    /// create a row for selecting a commit date
    ///
    /// - Parameters:
    ///   - commitDate: the commit date
    ///   - date: starting date for create meaningful texts
    /// - Returns: the commit date
    func commitDateRow(commitDate:Date?, startingDate date: Date) -> BaseRow {
        let commitDateCreator = SelectableCommitDatesCreator()
        let tuples = commitDateCreator.selectableCommitDates(startingWith: date, numberOfDays: 7, includingDate: commitDate)
        
        return PushRow<CommitDateTuple>() { row in
            row.tag = EditTaskFormTag.commitDateTag.rawValue
            row.title = "Select a commit date"
            row.value = commitDateCreator.dateAsTuple(date: commitDate)
            row.options = tuples
            }.onPresent { (_, to) in
                to.selectableRowCellUpdate = { cell, row in
                    cell.textLabel?.text = row.selectableValue?.text
                }
            }.cellUpdate { (cell,row) in
                cell.textLabel?.text = "Commit Date"
                cell.detailTextLabel?.text = row.value?.text
        }
    }
    
    /// a row with remarks for the tasks
    ///
    /// - Parameter remarks: the remakrs
    /// - Returns: a row with remarks for a date
    func remarksRow(remarks:String?) -> BaseRow {
        return TextAreaRow() {
                $0.placeholder = "Remarks on your task"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
        }
    }
    
    // MARK: Helper methods to create needed data lists for the Eureka rows
    
    /// an array of selectable goals for this actionable
    ///
    /// - Returns: the array
    /// - Throws: a core data exception
    func selectableGoals() -> [Goal] {
        do {
            let strategyOrderManager = StrategyOrderManager(manager: self.manager)
            let goals = try strategyOrderManager.goalsByPrio(withTypes: [GoalType.userGoal] )
            return goals
        }
        catch let error {
            NSLog("couldn't fetch the selectable goals: \(error)")
            return []
        }
    }
    
}
