//
//  CommitDatesCreator.swift
//  YourGoals
//
//  Created by André Claaßen on 17.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation

/// a tuple representing a commit date in the future and a string representation
struct CommitDateTuple:Equatable {
    static func ==(lhs: CommitDateTuple, rhs: CommitDateTuple) -> Bool {
        return lhs.date == rhs.date
    }
    
    let text:String
    let date:Date?
}

/// utility class for creating a list of commit dates
class SelectableCommitDatesCreator {
    
    /// convert a commit date to a tuple with a readable text explanatin
    ///
    /// - Parameter date: the date
    /// - Returns: the tuple
    func dateAsTuple(date:Date?) -> CommitDateTuple {
        let text = date == nil ? "No commit date" : date!.formattedWithTodayTommorrowYesterday()
        return CommitDateTuple(text: text, date: date)
    }
    
    /// create a list of commit dates for the next 7 days with a string
    /// representation of the date
    ///
    /// None (date = nil)
    /// Today
    /// Tommorrow
    /// Tuesday (12/19/2017) (for 19.12.2017
    /// Wednesday
    ///
    /// - Parameters:
    ///   - date: start date of the list
    ///   - numberOfDays: a number of dates
    ///   - includingDate: a date which should be included in the list
    ///
    /// - Returns: a list of formatted dates
    func selectableCommitDates(startingWith date:Date, numberOfDays:Int, includingDate:Date? ) -> [CommitDateTuple] {
        
        guard let range = Calendar.current.dateRange(startDate: date.day(), steps: numberOfDays-1) else {
            NSLog("couldn't create a date range for startDate \(date) with days")
            return []
        }
        
        let dates = Array(range)
        var tuples = dates.map(dateAsTuple)
        tuples.insert(dateAsTuple(date: nil), at: 0)
        if let includingDate = includingDate {
            let tuple = tuples.first { $0.date?.compare(includingDate.day()) == .orderedSame }
            if tuple == nil {
                tuples.insert(dateAsTuple(date: includingDate.day()), at: 1)
            }
        }
     
        return tuples
    }
}
