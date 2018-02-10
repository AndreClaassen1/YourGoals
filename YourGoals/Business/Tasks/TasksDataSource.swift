//
//  TaskPositioningProtocol.swift
//  YourGoals
//
//  Created by André Claaßen on 01.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// a behavivor changed by using the switching protocol
///
/// - state: the state of the actionable is changed
/// - commitment: the commitment of the actionable is changed
/// - progress: the progress of the actionable is changed
enum ActionableBehavior {
    case state
    case commitment
    case progress
    case tomorrow
}

/// protocol for fetching actionables
protocol ActionableDataSource {
    /// fetch a ordered array of actionables fromt he data source
    ///
    /// - Parameter date: fetch items for this date
    /// - Returns: an ordered array of actionables
    /// - Throws: core data exception
    func fetchActionables(forDate date: Date) throws -> [Actionable]
    
    /// retrieve the reordering protocol, if the datasource allows task reordering
    ///
    /// - Returns: a protocol for exchange items
    func positioningProtocol() -> ActionablePositioningProtocol?
    
    /// get a switch protocol for a specific behavior if available for this actionable data source
    ///
    /// - Returns: a switch protol
    func switchProtocol(forBehavior behavior: ActionableBehavior) -> ActionableSwitchProtocol?
}

protocol ActionablePositioningProtocol {
    /// after a reorder is done, a task has changed its position from the old offset to the new offset
    ///
    /// - Parameters:
    ///   - tasks: original tasks
    ///   - fromPosition: old position of the task in the array
    ///   - toPosition: new position for the task in the array
    /// - Returns: updated task order
    func updatePosition(actionables: [Actionable], fromPosition: Int, toPosition: Int) throws
}

/// switch the behavior of an actionable-
/// the behaviour could be a state, a commitment or a progress
protocol ActionableSwitchProtocol {
    func switchBehavior(forActionable actionable: Actionable, atDate date: Date) throws
    func isBehaviorActive(forActionable actionable: Actionable, atDate date: Date) -> Bool
}





