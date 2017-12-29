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
    static let startDate = "startDate"
    static let targetDate = "targetDate"
    static let visionImage = "visionImage"
    static let deleteButton = "deleteButton"
}

extension EditGoalFormController {
    
    /// configure the eureka form
    ///
    /// - Parameters:
    ///   - form: the eureka form
    ///   - goal: configure the form with the goal
    ///   - newEntry: true, if it is a new entry
    ///   - date: configure the selection of the commit dates with the current date as a starting poitn
    func configure(form: Form, withInfo goalInfo: GoalInfo, newEntry: Bool, todayGoal: Bool) {
        self.createForm(form: form, newEntry: newEntry, todayGoal: todayGoal)
        self.setValues(forGoalInfo: goalInfo)
    }
    
    /// create the eureka form for editing a goal
    ///
    /// - Parameters:
    ///   - form: the eureka form
    ///   - newEntry: true, if its is a new entry. old entries get an additional
    ///               delete button
    func createForm(form: Form, newEntry: Bool, todayGoal: Bool) {
        form
            +++ Section()
            <<< TextRow(tag: GoalFormTag.goalName).cellSetup { cell, row in
                cell.textField.placeholder = "Enter your goal"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesAlways
            }
            
            <<< ImageRow(GoalFormTag.visionImage) {
                $0.title = "Image for your goal"
            }
            
            <<< TextAreaRow(GoalFormTag.reason) {
                $0.placeholder = "The real reason for your goal"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }
            
            +++ Section()
            
            <<< DateRow(GoalFormTag.startDate) {
                $0.title = "Start Date"
                $0.hidden = Condition.init(booleanLiteral: todayGoal)
            }
            
            <<< DateRow(GoalFormTag.targetDate) {
                $0.title = "Target Date for Goal"
                $0.hidden = Condition.init(booleanLiteral: todayGoal)
            }
            
            +++ Section()
            
            <<< ButtonRow(GoalFormTag.deleteButton) {
                $0.title = "Delete Goal"
                $0.hidden = Condition.init(booleanLiteral: newEntry || todayGoal)
                }.cellSetup({ (cell, row) in
                    cell.backgroundColor = UIColor.red
                    cell.tintColor = UIColor.white
                }).onCellSelection{ _, _ in
                    self.deleteClicked()
        }
    }
    
    /// fill the rows of the form with the values of the goalInfo object
    ///
    /// - Parameter goalInfo: the goal Info
    func setValues(forGoalInfo goalInfo:GoalInfo) {
        var values = [String: Any?]()
        
        values[GoalFormTag.goalName] = goalInfo.name
        values[GoalFormTag.reason] = goalInfo.reason
        let startDate = goalInfo.startDate ?? Date()
        values[GoalFormTag.startDate] = startDate
        values[GoalFormTag.targetDate] = goalInfo.targetDate ?? startDate.addDaysToDate(30)
        values[GoalFormTag.visionImage] = goalInfo.image
        
        form.setValues(values)
    }
    
    /// retrieve values from the form
    ///
    /// - Parameter form: the form
    /// - Returns: the values
    func goalInfoFromValues(form: Form) -> GoalInfo {
        let values = form.values()
        
        let name = values[GoalFormTag.goalName] as! String?
        let reason = values[GoalFormTag.reason] as! String?
        let startDate = values[GoalFormTag.startDate] as! Date?
        let targetDate = values[GoalFormTag.targetDate] as! Date?
        let image = values[GoalFormTag.visionImage] as! UIImage?
        
        return GoalInfo(name: name, reason: reason, startDate: startDate, targetDate: targetDate, image: image, prio: 999)
    }
}
