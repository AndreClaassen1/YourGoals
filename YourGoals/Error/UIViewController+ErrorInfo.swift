//
//  UIViewController+ErrorInfo.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import CSNotificationView

extension UIViewController {
    
    func showNotification(forError error: Error) {
        let message = error.localizedDescription
        CSNotificationView.show(in: self.navigationController, style: CSNotificationViewStyle.error, message: message)
    }
}
