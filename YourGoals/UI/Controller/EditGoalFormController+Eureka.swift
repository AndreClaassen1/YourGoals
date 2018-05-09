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
    static let backburned = "backburned"
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
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.backgroundColor = UIColor.red
                        cell.tintColor = UIColor.white
                    }
                    else {
                        cell.backgroundColor = UIColor.white
                        cell.tintColor = UIColor.black
                    }
                })
            
            <<< ImageRow(GoalFormTag.visionImage) {
                $0.sourceTypes = .PhotoLibrary
                $0.add(rule: RuleRequired())
                $0.title = "Image for your goal"
            }
            
            <<< TextAreaRow(GoalFormTag.reason) {
                $0.placeholder = "The real reason for your goal"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }
            
            +++ Section()
            
            <<< DateRow(GoalFormTag.startDate) {
                $0.title = "Starting Date"
                $0.hidden = Condition.init(booleanLiteral: todayGoal)
                $0.add(rule: RuleRequired())
            }
            
            <<< DateRow(GoalFormTag.targetDate) { row in
                row.title = "Target Date"
                row.hidden = Condition.init(booleanLiteral: todayGoal)
                row.add(rule: RuleClosure<Date> { targetDate in
                    guard let startDate = (form.rowBy(tag: GoalFormTag.startDate) as! DateRow).value else { return nil }
                    guard let targetDate = targetDate else { return nil }
                    
                    if startDate.compare(targetDate) == .orderedDescending {
                        return ValidationError(msg: "the target date must be greater than the start date")
                    }
                    
                    return nil
                })
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesAlways
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.backgroundColor = UIColor.red
                    } else {
                        cell.backgroundColor = UIColor.white
                    }
            }
            
            +++ Section()
            <<< SwitchRow(GoalFormTag.backburned) {
                $0.title = "Backburn Goal?"
            }
            
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
        if let image = goalInfo.image {
            values[GoalFormTag.visionImage] = image
        } else {
            values[GoalFormTag.visionImage] = #imageLiteral(resourceName: "Success")
        }
        values[GoalFormTag.backburned] = goalInfo.backburned

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
        let startDate = values[GoalFormTag.startDate] as? Date
        let targetDate = values[GoalFormTag.targetDate] as? Date
        let image = values[GoalFormTag.visionImage] as! UIImage?
        let backburned = values[GoalFormTag.backburned] as! Bool
        
        return GoalInfo(name: name, reason: reason, startDate: startDate, targetDate: targetDate, image: image, prio: 999, backburned: backburned)
    }
}
