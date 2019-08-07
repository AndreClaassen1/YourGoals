//
//  CircleViewTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 03.08.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class CircleViewTests: XCTestCase {

    func testCircleProgress() {
        // setup
        let frame = CGRect(x: 0, y: 0, width: 400, height: 200)
        
        // act
        let circleView = CircleProgressView(frame: frame)

        // test
        XCTAssertNotNil(circleView.circle)
        XCTAssertNotNil(circleView.circleBackground)
    }
}
