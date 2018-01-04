//
//  CalculateColorsTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 04.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import XCTest
import UIKit
@testable import YourGoals

class CalculateColorsTests:XCTestCase {
 
    var testColors:[UIColor]!
    var colorCalculator:ColorCalculator!
    
    override func setUp() {
        super.setUp()
        
        self.testColors = [UIColor.green, UIColor.yellow, UIColor.red]
        self.colorCalculator = ColorCalculator(colors: testColors)
    }
    
    func testCalculateColorsAt50Percent() {
        // setup
        
        // act
        let color = colorCalculator.calculateColor(percent: 0.5)
        
        // test
        XCTAssertEqual(UIColor.yellow, color)
    }

    func testCalculateColorsAt0Percent() {
        // setup
        
        // act
        let color = colorCalculator.calculateColor(percent: 0)
        
        // test
        XCTAssertEqual(UIColor.green, color)
    }
    
    func testCalculateColorsAt100Percent() {
        // setup
        
        // act
        let color = colorCalculator.calculateColor(percent: 1.0)
        
        // test
        XCTAssertEqual(UIColor.red, color)
    }
    
    // calculate color between green and yello
    // open class var green: UIColor { get } // 0.0, 1.0, 0.0 RGB
    // open class var yellow: UIColor { get } // 1.0, 1.0, 0.0 RGB
    
    // result:    0.5 1.0, 0.0
    func testCalculateColorsAt25Percent() {
        // setup
        
        // act
        let color = colorCalculator.calculateColor(percent: 0.25)
        
        // test
        XCTAssertEqual(UIColor(red: 0.5, green: 1.0, blue: 0.0, alpha: 1.0), color)
    }
}
