//
//  ActionableBehaviorButton.swift
//  YourGoals
//
//  Created by André Claaßen on 10.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import MGSwipeTableCell

extension MGSwipeButton {
    convenience init(properties:(title: String, titleColor: UIColor?, backgroundColor: UIColor)) {
        self.init(title: properties.title, backgroundColor: properties.backgroundColor)
        if let titleColor = properties.titleColor  {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
}


/// this class helps to create swipe buttons with the correct colors and titles depending on the state of the wanted behavior
class ActionableSwipeButtonCreator {
    
    /// create a swipe buttion, if the data source provides a behavior for the swipe button
    ///
    /// - Parameters:
    ///   - date: for this date
    ///   - actionable: for this actionable (a task or a habit)
    ///   - behavior: a behaviour, like commitment, active or progressing
    ///   - dataSource: a actionable data source ( list of ordered tasks or habits)
    /// - Returns: a swipe button or nil, if the data source is not providing an behaviour
    func create(date: Date, actionable: Actionable, behavior:ActionableBehavior, dataSource: ActionableDataSource) -> MGSwipeButton? {
        guard let switchProtocol = dataSource.switchProtocol(forBehavior: behavior) else {
            return nil
        }
        
        let properties = buttonProperties(behaviorIsActive: switchProtocol.isBehaviorActive(forActionable: actionable, atDate: date), behavior: behavior)
        let button = MGSwipeButton(properties: properties)
        return button
    }

    /// create swipe buttons for the given behaviors, if the data source provide a behavior for the switch button
    ///
    /// - Parameters:
    ///   - date: for this date
    ///   - actionable: for this actionable (a task or a habit)
    ///   - behaviors: an array of behaviors
    ///   - dataSource: a actionable data source ( list of ordered tasks or habits)
    /// - Returns: an arra of swipe buttons
    func createSwipeButtons(forDate date: Date, forActionable actionable:Actionable, forBehaviors behaviors:[ActionableBehavior], dataSource: ActionableDataSource) -> [MGSwipeButton] {
        var buttons = [MGSwipeButton]()
        
        for behavior in behaviors {
            if let button = create(date: date, actionable: actionable, behavior: behavior, dataSource: dataSource ) {
                buttons.append(button)
            }
        }
        
        return buttons
    }
    
    /// creates a tuple with properties for coloring and give the button a tile
    ///
    /// - Parameters:
    ///   - behaviorIsActive: true, if the buttion is active for the wanted behavior (progressing committed or active state)
    ///   - behavior: the behavior
    /// - Returns: a tuple with properties to create a MGSwipeButton
    func buttonProperties(behaviorIsActive:Bool, behavior: ActionableBehavior) -> (title: String, titleColor: UIColor?, backgroundColor: UIColor) {
        
        switch behavior {
        case .commitment:
            if behaviorIsActive {
                return ("Someday", UIColor.black, UIColor.gray)
            } else {
                return ("Today", UIColor.black, UIColor.yellow)
            }
        
        case .progress:
            if behaviorIsActive {
                return ("Stop", nil, UIColor.red)
            } else {
                return ("Start", nil, UIColor.green)
            }
            
        case .state:
            if behaviorIsActive {
                return ("Done", nil, UIColor.blue)
            } else {
                return ("Open", nil, UIColor.blue)
            }
        case .tomorrow:
            if behaviorIsActive {
                return (" ", UIColor.black, UIColor.white)
            } else {
                return ("Tomorrow", UIColor.black, UIColor.blue)
            }
       }
    }
}
