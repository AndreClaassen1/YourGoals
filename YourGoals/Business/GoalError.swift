
//
//  Goal+Image.swift
//  YourGoals
//
//  Created by André Claaßen on 28.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CoreData
import UIKit


enum GoalError : Error{
    case imageNotJPegError
}

extension GoalError:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .imageNotJPegError:
            return "Couldn't translate this image to an jpeg error"
        }
    }
}
