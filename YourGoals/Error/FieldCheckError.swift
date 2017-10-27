//
//  CheckError.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

enum FieldCheckError:Error {
    case invalidInput(field:String, hint:String)
}

extension FieldCheckError:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidInput(let field, let hint):
                return "Error in Field: \(field). Hint: \(hint)"
        }
    }
}
