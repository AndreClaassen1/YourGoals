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
struct ActionableFormTag  {
    static let task = "Task"
    static let goal = "Goal"
    static let url = "Url"
    static let image = "Image"
    static let beginTimeSwitch = "BeginTimeSwitch"
    static let beginTime = "BeginTime"
    static let duration = "Duration"
    static let commitDate = "CommitDate"
    static let repetitions = "Repetitions"
}

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
            <<< CountDownRow(ActionableFormTag.duration) {
                $0.title = L10n.timeboxYourTask
            }
            
            <<< URLRow(ActionableFormTag.url) {
                $0.title = L10n.additionalURL
            }
            <<< ImageRow(ActionableFormTag.image) {
                $0.sourceTypes = .PhotoLibrary
                $0.title = L10n.additionalImage
            }

            <<< commitDateRow()
            <<< SwitchRow(ActionableFormTag.beginTimeSwitch){
                $0.title = L10n.doYouWantAFixedBeginTime
            }
            <<< beginTimeRow()
            <<< repetitionRow()
            +++ Section()
            <<< parentGoalRow()
            <<< remarksRow(remarks: nil)
            +++ Section()
            <<< ButtonRow() {
                $0.title = L10n.delete + " " + type.asString()
                $0.hidden = Condition.function([], { _ in newEntry })
                }.cellSetup({ (cell, row) in
                    cell.backgroundColor = UIColor.red
                    cell.tintColor = UIColor.white
                }).onCellSelection{ _, _ in
                    self.deleteClicked()
        }
    }
    
    func commitDateTuple(fromDate date: Date?) -> CommitDateTuple {
        let commitDateCreator = SelectableCommitDatesCreator()
        return date == nil ? commitDateCreator.dateAsTuple(date: nil, type: .noCommitDate) : commitDateCreator.dateAsTuple(date: date, type: .explicitCommitDate)
    }
    
    /// set the values of the form based on the actionableInfo for the specific date
    ///
    /// - Parameters:
    ///   - actionableInfo: the actionable info
    ///   - date: the date for the row options for the commit date
    func setValues(form: Form, forInfo actionableInfo: ActionableInfo, forDate date: Date) {
        
        var values = [String: Any?]()
        values[ActionableFormTag.task] = actionableInfo.name
        values[ActionableFormTag.goal] = actionableInfo.parentGoal
        values[ActionableFormTag.url] = actionableInfo.url
        values[ActionableFormTag.image] = actionableInfo.image
        if let beginTime = actionableInfo.beginTime {
            values[ActionableFormTag.beginTimeSwitch] = true
            values[ActionableFormTag.beginTime] = beginTime
        } else {
            values[ActionableFormTag.beginTimeSwitch] = false
            values[ActionableFormTag.beginTime] = nil
        }
        
        values[ActionableFormTag.commitDate] = commitDateTuple(fromDate: actionableInfo.commitDate)
        values[ActionableFormTag.duration] = Date.timeFromMinutes(Double(actionableInfo.size))
        
        let commitDateCreator = SelectableCommitDatesCreator()
        let pushRow:PushRow<CommitDateTuple> = form.rowBy(tag: ActionableFormTag.commitDate)!
        let tuples = commitDateCreator.selectableCommitDates(startingWith: date, numberOfDays: 7, includingDate: actionableInfo.commitDate)
        pushRow.options = tuples
        
        form.setValues(values)
    }
    
    /// read the input values out of the form and create an ActionableInfo
    ///
    /// - Returns: the actionableinfo
    func getActionableInfoFromValues(form: Form) -> ActionableInfo {
        let values = form.values()

        guard let name = values[ActionableFormTag.task] as? String? else {
            fatalError("There should be a name value")
        }
        
        let goal = values[ActionableFormTag.goal] as? Goal
        let commitDateTuple = values[ActionableFormTag.commitDate] as? CommitDateTuple
        let beginTimeSwitched = (values[ActionableFormTag.beginTimeSwitch] as? Bool) ?? false
        let beginTime:Date? = beginTimeSwitched ? values[ActionableFormTag.beginTime] as? Date : nil
        
        let size = Float((values [ActionableFormTag.duration] as? Date)?.convertToMinutes() ?? 0.0)
        let repetitions = values[ActionableFormTag.repetitions] as? Set<ActionableRepetition>
        
        let url = values[ActionableFormTag.url] as? URL
        let urlString = url?.absoluteString
        
        let image = values[ActionableFormTag.image] as? UIImage
        let imageData = image == nil ? nil :  image!.jpegData(compressionQuality: 0.6)

        
        return ActionableInfo(type: self.editActionableType, name: name, commitDate: commitDateTuple?.date,
                              beginTime: beginTime,
                              parentGoal: goal, size: size, urlString: urlString,
                              imageData: imageData, repetitions: repetitions)
    }
    
    // MARK: - Row creating helper functions
    
    /// create a row with all repetitions base
    func repetitionRow() -> BaseRow {
        let row = MultipleSelectorRow<ActionableRepetition>() {
            $0.title = L10n.repetition
            $0.tag = ActionableFormTag.repetitions
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
        let row = TextRow(tag: ActionableFormTag.task).cellSetup { cell, row in
            cell.textField.placeholder = L10n.pleaseEnterYourTask
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesAlways
        }
        
        return row
    }
    
    /// create a row for selecting a goal
    ///
    /// - Returns: the row
    func parentGoalRow() -> BaseRow {
        return PushRow<Goal>(ActionableFormTag.goal) { row in
            row.title = L10n.selectAGoal
            row.options = selectableGoals()
            }.onPresent{ (_, to) in
                to.selectableRowCellUpdate = { cell, row in
                    cell.textLabel?.text = row.selectableValue?.name
                }
            }.cellUpdate{ (cell, row) in
                cell.textLabel?.text = L10n.goal
                cell.detailTextLabel?.text = row.value?.name
        }
    }
    
    /// create a row for selecting a commit date
    ///
    /// info about coding popup is from http://www.thomashanning.com/uipopoverpresentationcontroller/
    ///
    /// - Parameters:
    ///   - date: starting date for create meaningful texts
    ///
    /// - Returns: the commit date
    func commitDateRow() -> BaseRow {
        
        return PushRow<CommitDateTuple>() { row in
            row.tag = ActionableFormTag.commitDate
            row.title = L10n.selectACommitDate
            row.options = []
            }.onPresent { (_, to) in
                to.selectableRowCellUpdate = { cell, row in
                    cell.textLabel?.text = row.selectableValue?.text
                }
            }.cellUpdate { (cell,row) in
                cell.textLabel?.text = L10n.commitDate
                cell.detailTextLabel?.text = row.value?.text
            }.onChange{ (row) in
                if row.value?.type == .userDefinedCommitDate {
                    self.showPopOverForCommitDate(row: row)
            }
        }
    }
    
    /// show the time row for an explicit begin time only when the switch for the row is on.
    ///
    /// - Returns: a row for the begin time
    func beginTimeRow() -> BaseRow {
        return TimeRow() {
            row in
            row.tag = ActionableFormTag.beginTime
            row.hidden = .function([ActionableFormTag.beginTimeSwitch], { form -> Bool in
                let row: RowOf<Bool>! = form.rowBy(tag: ActionableFormTag.beginTimeSwitch)
                return !(row.value ?? false)
            })
            row.title = L10n.selectABeginTime
        }
    }
    
    func showPopOverForCommitDate(row: PushRow<CommitDateTuple>) {
        let view = row.cell.contentView
        let commitDateController = CommitDateFormController()
        commitDateController.modalPresentationStyle = UIModalPresentationStyle.popover
        commitDateController.delegate = self
        self.present(commitDateController, animated: true, completion: nil)
        let popoverPresentationController = commitDateController.popoverPresentationController
        popoverPresentationController?.sourceView = view
    }
        
    /// create a row with remarks for the tasks
    ///
    /// - Parameter remarks: the remakrs
    /// - Returns: a row with remarks for a date
    func remarksRow(remarks:String?) -> BaseRow {
        return TextAreaRow() {
            $0.placeholder = L10n.remarksOnYourTask
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

extension EditActionableFormController : CommitDateFormControllerDelegate {
    func saveCommitDate(commitDate: Date?) {
        let row = self.form.rowBy(tag: ActionableFormTag.commitDate) as! PushRow<CommitDateTuple>
        row.value = commitDateTuple(fromDate: commitDate)
    }
}
