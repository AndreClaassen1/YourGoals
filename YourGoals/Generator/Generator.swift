//
//  Generator.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 26.06.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation

protocol GeneratorProtocol {
    func generate() throws
}

class Generator  {
    let manager:GoalsStorageManager!
    
    init(manager:GoalsStorageManager) {
        self.manager = manager
    }
}
