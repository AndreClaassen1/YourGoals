//
//  EditGoalFormController+Eureka.swift
//  YourGoals
//
//  Created by André Claaßen on 27.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit
import Eureka

/// the form tags for the FormViewModel
struct GoalFormTag  {
    static let goalName = "GoalName"
    static let reason = "reason"
    static let targetDate = "targetDate"
    static let visionImage = "visionImage"
}


extension EditGoalFormController {
    
    /// configure the eureka form
    ///
    /// - Parameters:
    ///   - form: the eureka form
    ///   - goal: configure the form with the goal
    ///   - newEntry: true, if it is a new entry
    ///   - date: configure the selection of the commit dates with the current date as a starting poitn
    func configure(form: Form, withInfo goalInfo: GoalInfo, newEntry: Bool) {
    }
    
    /// create the eureka form for editing a goal
    ///
    /// - Parameters:
    ///   - form: the eureka form
    ///   - newEntry: true, if its is a new entry. old entries get an additional
    ///               delete button
    func createForm(form: Form, newEntry: Bool) {
        form
            +++ Section()
            <<< goalNameRow()
            <<< imagePickerRow()
            <<< reasonRow()
            <<< targetDateRow()
            <<< deleteButtonRow(newEntry: newEntry)
    }
    
    /// create a row for editing the goals name
    ///
    /// - Returns: a base row
    func goalNameRow() -> BaseRow {
        let row = TextRow(tag: GoalFormTag.goalName).cellSetup { cell, row in
            cell.textField.placeholder = "Please enter your goal"
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesAlways
        }
        
        return row
    }
    
    /// create a row with remarks for the tasks
    ///
    /// - Parameter remarks: the remakrs
    /// - Returns: a row with remarks for a date
    func reasonRow() -> BaseRow {
        return TextAreaRow() {
            $0.tag = GoalFormTag.reason
            $0.placeholder = "The reason for your goal"
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
        }
    }
    
    func targetDateRow() -> BaseRow {
        return TextRow()
    }

    func imagePickerRow() -> BaseRow {
        return TextRow()
    }
    
    func deleteButtonRow(newEntry: Bool) -> BaseRow {
        return ButtonRow() {
            $0.title = "Delete Goal"
            $0.hidden = Condition.function([], { _ in newEntry })
            }.cellSetup({ (cell, row) in
                cell.backgroundColor = UIColor.red
                cell.tintColor = UIColor.white
            }).onCellSelection{ _, _ in
                self.deleteClicked()
        }
    }
    
    func goalInfoFromValues(form: Form) -> GoalInfo {
        return GoalInfo()
    }
}
