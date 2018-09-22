//
//  EditActionableFormController+Eureka.swift
//  YourGoals
//
//  Created by André Claaßen on 26.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

/// the form tags for the FormViewModel
///
/// **Hint**: A tag is a unique field identifier
///
/// - task: the tag id of the task
/// - goal: the tag id of the selectable goal
/// - commitDate: the task id of the commit date
struct TaskFormTag  {
    static let task = "Task"
    static let goal = "Goal"
    static let duration = "Duration"
    static let commitDate = "CommitDate"
    static let repetitions = "Repetitions"
}

typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"


// MARK: - Extension for creating and handling the Eureka Form
extension EditActionableFormController {
    
    /// configure the eureka form
    ///
    /// - Parameters:
    ///   - form: the eureka form
    ///   - actionableInfo: configure the form with values from the actionable info
    ///   - newEntry: true, if it is a new entry
    ///   - date: configure the selection of the commit dates with the current date as a starting poitn
    func configure(form: Form, withInfo actionableInfo: ActionableInfo, newEntry: Bool, forDate date: Date) {
        createForm(form: form, forType: actionableInfo.type, newEntry: newEntry)
        setValues(form: form, forInfo: actionableInfo, forDate: date)
    }
    
    /// create the eureka form based on the actionable info for the specific date
    ///
    /// ** Hint **: The date is needed to create a range of selectable commit date
    ///             textes like today, tomorrow and so on.
    /// - Parameters:
    ///   - form: the eureka form
    ///   - type: the type of the actionable: .task or .habit
    ///   - newEntry: true, if its is a new entry. old entries get an additional
    ///               delete button
    func createForm(form: Form, forType type: ActionableType, newEntry: Bool) {
        form
            +++ Section()
            <<< taskNameRow()
            +++ Section() { $0.hidden = Condition.function([], { _ in type == .habit }) }
            <<< CountDownRow(TaskFormTag.duration) {
                $0.title = "Timebox your task"
            }
            
            <<< commitDateRow()
            <<< repetitionRow()
            +++ Section()
            <<< parentGoalRow()
            <<< remarksRow(remarks: nil)
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Delete \(type.asString())"
                $0.hidden = Condition.function([], { _ in newEntry })
                }.cellSetup({ (cell, row) in
                    cell.backgroundColor = UIColor.red
                    cell.tintColor = UIColor.white
                }).onCellSelection{ _, _ in
                    self.deleteClicked()
        }
    }
    
    /// set the values of the form based on the actionableInfo for the specific date
    ///
    /// - Parameters:
    ///   - actionableInfo: the actionable info
    ///   - date: the date for the row options for the commit date
    func setValues(form: Form, forInfo actionableInfo: ActionableInfo, forDate date: Date) {
        let commitDateCreator = SelectableCommitDatesCreator()
        
        var values = [String: Any?]()
        values[TaskFormTag.task] = actionableInfo.name
        values[TaskFormTag.goal] = actionableInfo.parentGoal
        values[TaskFormTag.commitDate] = commitDateCreator.dateAsTuple(date: actionableInfo.commitDate)
        values[TaskFormTag.duration] = Date.timeFromMinutes(Double(actionableInfo.size))
        
        let pushRow:PushRow<CommitDateTuple> = form.rowBy(tag: TaskFormTag.commitDate)!
        let tuples = commitDateCreator.selectableCommitDates(startingWith: date, numberOfDays: 7, includingDate: actionableInfo.commitDate)
        pushRow.options = tuples
        
        form.setValues(values)
    }
    
    /// read the input values out of the form and create an ActionableInfo
    ///
    /// - Returns: the actionableinfo
    func getActionableInfoFromValues(form: Form) -> ActionableInfo {
        let values = form.values()

        guard let name = values[TaskFormTag.task] as? String? else {
            fatalError("There should be a name value")
        }
        
        let goal = values[TaskFormTag.goal] as? Goal
        let commitDateTuple = values[TaskFormTag.commitDate] as? CommitDateTuple
        let size = Float((values [TaskFormTag.duration] as? Date)?.convertToMinutes() ?? 0.0)
        let repetitions = values[TaskFormTag.repetitions] as? Set<ActionableRepetition>
        
        return ActionableInfo(type: self.editActionableType, name: name, commitDate: commitDateTuple?.date, parentGoal: goal, size: size, repetitions: repetitions)
    }
    
    // MARK: - Row creating helper functions
    
    /// create a row with all repetitions base
    func repetitionRow() -> BaseRow {
        let row = MultipleSelectorRow<ActionableRepetition>() {
            $0.title = "Repetition"
            $0.tag = TaskFormTag.repetitions
            $0.options = ActionableRepetition.values()
            $0.value = self.editActionable?.repetitions ?? []
            }
            .onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
        }

        return row
    }
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

    
    /// create a row for editing the task name
    ///
    /// - Returns: a base row
    func taskNameRow() -> BaseRow {
        let row = TextRow(tag: TaskFormTag.task).cellSetup { cell, row in
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
        return PushRow<Goal>(TaskFormTag.goal) { row in
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
            row.tag = TaskFormTag.commitDate
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
    
    /// create a row with remarks for the tasks
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
            let settings = SettingsUserDefault()
            let strategyOrderManager = StrategyOrderManager(manager: self.manager)
            let goals = try strategyOrderManager.goalsByPrio(withTypes: [GoalType.userGoal], withBackburned: settings.backburnedGoals )
            return goals
        }
        catch let error {
            NSLog("couldn't fetch the selectable goals: \(error)")
            return []
        }
    }
}
