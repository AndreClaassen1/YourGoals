//
//  RepetitionValueEncoder.swift
//  YourGoals
//
//  Created by André Claaßen on 29.07.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

enum RepetitionValueError:Error {
    case jsonNotData
    case stringNotJson
}

/// a helper class for encoding a set of repetitions
class RepetitionValueEncoder {
    
    /// create the repetionValue string out of a string of repetitions
    ///
    /// - Parameter repetitions: a set of repetitoins
    /// - Returns: a encoded string of repetitions
    /// - Throws: jsonNotData exception
    func repetitionValue(fromSet repetitions: Set<ActionableRepetition>) throws -> String {
        let encoder = JSONEncoder()
        
        let jsonData = try encoder.encode(repetitions)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw RepetitionValueError.jsonNotData
        }
        return jsonString
    }
}

class RepetitionValueDecoder {
    
    func actionableRepetitions(fromRepetitionValue value: String) throws -> Set<ActionableRepetition> {
        let decoder = JSONDecoder()
        
        guard let json = value.data(using: .utf8) else {
            throw RepetitionValueError.stringNotJson
        }
        
        let actionableRepetitions = try decoder.decode(Set<ActionableRepetition>.self, from: json)
        return actionableRepetitions
    }
}
