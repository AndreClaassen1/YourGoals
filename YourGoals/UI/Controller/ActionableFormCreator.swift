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

// MARK: - ActionableInfo

extension ActionableInfo {
    
    /// create an actionable info based on the values of the eureka actionable form
    ///
    /// - Parameters:
    ///   - type: type of the acgtinoable
    ///   - values: the values
    init(type: ActionableType, values: [String: Any?]) {
        guard let name = values[EditTaskFormTag.taskTag.rawValue] as? String? else {
            fatalError("There should be a name value")
        }
        
        let goal = values[EditTaskFormTag.goalTag.rawValue] as? Goal
        let commitDateTuple = values[EditTaskFormTag.commitDateTag.rawValue] as? CommitDateTuple
        
        self.init(type: type, name: name, commitDate: commitDateTuple?.date, parentGoal: goal)
    }
}

/// create an Eureka form for editing or creation actionables (tasks or habits)
class ActionableFormCreator:StorageManagerWorker {
    
    /// the Eureka form
    let form:Form
    
    /// a .task or .habit
    let type:ActionableType
    
    /// new entry or editing an existing enty
    let newEntry:Bool
    
    /// initialize the form creator with the (empty) eureka form and a storage managerand
    ///
    /// - Parameters:
    ///   - form: the eureka formand
    ///   - type: .habit or .task
    ///   - newEntry: create a task/habit or edit one
    ///   - manager: the storage manager
    init(form: Form, forType type: ActionableType, newEntry:Bool, manager: GoalsStorageManager) {
        self.form = form
        self.type = type
        self.newEntry = newEntry
        super.init(manager: manager)
    }
    
    /// create a form based on the actionable info for the specific date
    ///
    /// ** Hint **: The date is needed to create a range of selectable commit date
    ///             textes like today, tomorrow and so on.
    ///
    func createForm() {
        self.form
            +++ Section()
            <<< taskNameRow()
            <<< parentGoalRow()
            +++ Section() { $0.hidden = Condition.function([], { _ in self.type == .habit }) }
            <<< commitDateRow()
            +++ Section()
            <<< remarksRow(remarks: nil)
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Delete \(type.asString())"
                $0.hidden = Condition.function([], { _ in self.newEntry })
                }.cellSetup({ (cell, row) in
                    cell.backgroundColor = UIColor.red
                    cell.textLabel?.textColor = UIColor.white
                })
    }
    
    /// set the values of the form based on the actionableInfo for the specific date
    ///
    /// - Parameters:
    ///   - actionableInfo: the actionable info
    ///   - date: the date for the row options for the commit date
    func setValues(for actionableInfo: ActionableInfo, forDate date: Date) {
        let commitDateCreator = SelectableCommitDatesCreator()
        
        var values = [String: Any?]()
        values[EditTaskFormTag.taskTag.rawValue] = actionableInfo.name
        values[EditTaskFormTag.goalTag.rawValue] = actionableInfo.parentGoal
        values[EditTaskFormTag.commitDateTag.rawValue] = commitDateCreator.dateAsTuple(date: actionableInfo.commitDate)
        
        let pushRow:PushRow<CommitDateTuple> = self.form.rowBy(tag: EditTaskFormTag.commitDateTag.rawValue)!
        let tuples = commitDateCreator.selectableCommitDates(startingWith: date, numberOfDays: 7, includingDate: actionableInfo.commitDate)
        pushRow.options = tuples
        
        self.form.setValues(values)
    }
    
    /// read the input values out of the form and create an ActionableInfo
    ///
    /// - Returns: the actionableinfo
    func getActionableInfoFromValues() -> ActionableInfo {
        let values = self.form.values()
        return ActionableInfo(type: self.type, values: values)
    }
    
    // MARK: - Row creating helper functions
    
    /// create a row for editing the task name
    ///
    /// - Returns: a base row
    func taskNameRow() -> BaseRow {
        let row = TextRow(tag: EditTaskFormTag.taskTag.rawValue).cellSetup { cell, row in
            cell.textField.placeholder = "Please enter your task"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesAlways
        }
        
        return row
    }
    
    /// create a row for selecting a goal
    ///
    /// - Returns: the row
    func parentGoalRow() -> BaseRow {
        return PushRow<Goal>(EditTaskFormTag.goalTag.rawValue) { row in
            row.title = "Select a Goal"
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
    ///   - date: starting date for create meaningful texts
    ///
    /// - Returns: the commit date
    func commitDateRow() -> BaseRow {
        
        return PushRow<CommitDateTuple>() { row in
            row.tag = EditTaskFormTag.commitDateTag.rawValue
            row.title = "Select a commit date"
            row.options = []
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
