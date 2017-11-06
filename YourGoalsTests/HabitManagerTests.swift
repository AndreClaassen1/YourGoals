//
//  HabitManagerTests.swift
//  YourGoalsTests
//
//  Created by André Claaßen on 06.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

class HabitManagerTests: StorageManagerWorker {
    
    func testCheckHabitForDate() {
        // setup
        let dateTime = Date.dateTimeWithYear(2017, month: 11, day: 06, hour: 12, minute: 13, second: 0)
        let date = Date.dateWithYear(2017, month: 11, day: 06)
        let habit = HabitFactory(manager: self.manager).createHabit(name: "Test Habit")
        
        // act
        try! HabitManager(manager: self.manager).checkHabit(forHabit: habit, state: .checked , atDate: dateTime)
        
        // test
        let habitReloaded = self.manager.context.object(with: habit.objectID) as! Habit
        XCTAssert(habitReloaded.isChecked(forDate: date))
    }
    
    func testUnCheckHabitForDate() {
        // setup
        let dateTime = Date.dateTimeWithYear(2017, month: 11, day: 06, hour: 12, minute: 13, second: 0)
        let date = Date.dateWithYear(2017, month: 11, day: 06)
        let habit = HabitFactory(manager: self.manager).createHabit(name: "Test Habit")
        
        // act
        try! HabitManager(manager: self.manager).checkHabit(forHabit: habit, state: .checked , atDate: dateTime)
        try! HabitManager(manager: self.manager).checkHabit(forHabit: habit, state: .notChecked , atDate: dateTime)

        // test
        let habitReloaded = self.manager.context.object(with: habit.objectID) as! Habit
        XCTAssertFalse(habitReloaded.isChecked(forDate: date))
    }
}
