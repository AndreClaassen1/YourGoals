//
//  Task+Actionable.swift
//  YourGoals
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

extension Task:Actionable {
    
    /// encode and decode actionable repetitions to the internal representation
    var repetitions: Set<ActionableRepetition> {
        get {
            guard let repetitionValue = self.repetitionValue else {
                return []
            }
            
            let decoder = RepetitionValueDecoder()
            do {
                return try decoder.actionableRepetitions(fromRepetitionValue: repetitionValue)
            }
            catch let error {
                NSLog("couldn't parse repetitionValue: \(repetitionValue). error: \(error.localizedDescription)")
                return []
            }
        }
        
        set {
            let encoder = RepetitionValueEncoder()
            do {
                let repetitionValue = try encoder.repetitionValue(fromSet: newValue)
                if repetitionValue.isEmpty {
                    self.repetitionValue = nil
                } else {
                    self.repetitionValue = repetitionValue
                }
            }
            catch let error {
                NSLog("couldn't encode repetitonValue from set: \(newValue). error: \(error.localizedDescription)")
            }
        }
    }
    
    
    /// this is a task
    var type: ActionableType {
        return .task
    }
    
    func checkedState(forDate date: Date) -> ActionableState {
        return self.getTaskState()
    }
}
