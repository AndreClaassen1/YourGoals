//
//  ColorCalculator.swift
//  YourGoals
//
//  Created by André Claaßen on 03.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

/// calculate a color at a given position between 0.0 and 1.0 in a range of equally distributed colors
class ColorCalculator {
    let colors:[UIColor]
    
    /// the range of equally distributed colors
    ///
    /// - Parameter colors: array of colors
    init(colors: [UIColor]) {
        self.colors = colors
        assert(colors.count > 0)
    }
    
    /// calculate the color based on a interval between 0.0 and 1.0
    ///
    /// - Parameter percent: value between 0.0 and 1.0
    /// - Returns: the interpolated color from the array
    /// Example [red, yellow, green] => 2 color intevals
    /// 0.7 => 1.4
    func calculateColor(percent: CGFloat) -> UIColor {
        
        guard self.colors.count > 0 else {
            return colors[0]
        }
        
        let normalized = percent < 0.0 ? 0.0 : ( percent > 1.0 ? 1.0 : percent)
        if normalized == 1.0 {
            return colors.last!
        }
        
        let numberOfColorIntervals = (self.colors.count - 1)
        let position = normalized * CGFloat(numberOfColorIntervals)
        let interval = Int(position)
        let percentInInterval = position - CGFloat(interval)
        
        let colorStart = self.colors[interval]
        let colorEnd = self.colors[interval + 1]
        let colorInInterval = calculateColor(color1: colorStart, color2: colorEnd, percent: percentInInterval)
        return colorInInterval
    }

    /// calculate a color which lies in a color range between color 1 and color 2 (gradient)
    ///
    /// - Parameters:
    ///   - color1: starting color
    ///   - color2: ending color
    ///   - percent: percentage between 0.0 and 1.0
    /// - Returns: the color
    func calculateColor(color1: UIColor, color2: UIColor, percent: CGFloat) -> UIColor {
        let resultRed = color1.redValue + percent * (color2.redValue - color1.redValue)
        let resultGreen = color1.greenValue + percent * (color2.greenValue - color1.greenValue)
        let resultBlue = color1.blueValue + percent * (color2.blueValue - color1.blueValue)
        
        return UIColor(red: resultRed, green: resultGreen, blue: resultBlue, alpha: 1.0)
    }
}
