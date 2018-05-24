//
//  Task+Uri.swift
//  YourGoals
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    /// return the uri representation of this object as string
    var uri:String {
        return self.objectID.uriRepresentation().absoluteString
    }
}
