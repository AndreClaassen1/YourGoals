//
//  UIColor+rgb.swift
//  YourGoals
//
//  Created by André Claaßen on 04.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}
