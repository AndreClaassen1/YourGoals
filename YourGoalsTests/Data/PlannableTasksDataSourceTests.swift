//
//  PlannableTasksDataSourceTests
//  YourGoalsTests
//
//  Created by André Claaßen on 09.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import XCTest
@testable import YourGoals

/// tests for the PlannableTasksDataSource
class PlannableTasksDataSourceTests: StorageTestCase {
    
    func generateTasks(startDate date: Date, data: [(day:Int, tasks:Int)]) {
        let goal = self.testDataCreator.createGoal(name: "Test Goal")
        
        for d in data {
            let commitmentDate = date.addDaysToDate(d.day)
            for i in 0..<d.tasks {
                self.testDataCreator.createTask(name: "Task nr \(i) for \(commitmentDate)", commitmentDate: commitmentDate, forGoal: goal)
            }
        }
    }
    
    func testDataSourceWithThreeDaysWithTasks() {
        // given 3 days with tasks for this week
        
        let referenceDate = Date.dateWithYear(2018, month: 04, day: 01)
        let testData = [
            (day: 0, tasks: 3), // today
            (day: 1, tasks: 2), // tomorrow
            (day: 4, tasks: 1)
        ]
        
        generateTasks(startDate: referenceDate, data: testData)
        
        // when i read the datasource
        let dataSource = PlannableTasksDataSource(manager: self.manager, backburned: true)
        let sections = try! dataSource.fetchSections(forDate: referenceDate)
        
        // i've got 7 sections for the week with 3 sections with tasks
        XCTAssertEqual(7, sections.count)
        var numberOfSectionsWithTasks = 0
        
        for section in sections {
            let n = try! dataSource.fetchActionables(forDate: referenceDate, andSection: section)
            NSLog("[\(n.count)] = \(section)")
            if n.count > 0 {
                numberOfSectionsWithTasks += 1
            }
        }
        
        XCTAssertEqual(3, numberOfSectionsWithTasks)
    }
    
}
