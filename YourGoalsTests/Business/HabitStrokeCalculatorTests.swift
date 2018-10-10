//
//  HabitStrokeCalculatorTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 10.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
import CoreData
@testable import YourGoals

class  HabitStrokeCalculatorTests: StorageTestCase {

    func testStrokeCount() {
        // setup
        let referenceDate = Date.dateWithYear(2018, month: 10, day: 10)
        let goal = self.testDataCreator.createGoal(name: "Test Goal")
        let habit = self.testDataCreator.createHabit(forGoal: goal, name: "A test habit")
        
        // check the habit for the third time
        self.testDataCreator.check(habit: habit, forDate: referenceDate)
        self.testDataCreator.check(habit: habit, forDate: referenceDate.addDaysToDate(-1))
        self.testDataCreator.check(habit: habit, forDate: referenceDate.addDaysToDate(-2))
        
        // act
        let calculator = HabitStrokeCalculator()
        let strokeCount = calculator.calculateStrokeCount(forHabit: habit, andDate: referenceDate)
        
        // test
        XCTAssertEqual(3, strokeCount)
    }
}
