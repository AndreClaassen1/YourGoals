//
//  File.swift
//  YourGoals
//
//  Created by André Claaßen on 30.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CSNotificationView
import Eureka

extension UIViewController {
    
    func showNotification(forValidationErrors validationErrors: [ValidationError]) {
        var message = ""
        
        guard validationErrors.count > 0 else {
            return
        }
        
        if validationErrors.count == 1 {
            message = validationErrors[0].msg
        }
        else {
            message = "You have \(validationErrors.count) error(s)\n"
        }
        CSNotificationView.show(in: self.navigationController, style: CSNotificationViewStyle.error, message: message)
    }
}
