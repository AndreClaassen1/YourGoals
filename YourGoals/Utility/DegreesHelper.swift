//
//  DegreesHelper.swift
//  YourGoals
//
//  Created by André Claaßen on 09.08.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

/// convert degrees to radians
///
/// - Parameter angle: an angle in degrees
/// - Returns: an angle in radians
func degreesToRadians(angle:CGFloat) -> CGFloat {
    return (angle / 180.0) * .pi
}
