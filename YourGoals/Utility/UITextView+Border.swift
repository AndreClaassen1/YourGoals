//
//  UITextView+Border.swift
//  YourGoals
//
//  Created by André Claaßen on 30.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func showBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
