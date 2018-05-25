//
//  ProgressingInfo.swift
//  YourGoals WatchKit Extension
//
//  Created by André Claaßen on 25.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchKit

enum ProgressInterfaceState {
    case noData
    case illegalData
    case notProgressing
    case progressing
}

struct WatchProgressingInfo {
    let state:ProgressInterfaceState
    let taskName:String
    let referenceTime:Date
    let targetTime:Date
    let taskSize:TimeInterval
    let taskUri:String

    init() {
        self.state = .noData
        self.taskName = "no data"
        self.referenceTime = Date(timeIntervalSince1970: 0)
        self.targetTime = Date(timeIntervalSince1970: 0)
        self.taskSize = 0
        self.taskUri = ""
    }
    
    init(fromContext progressContext:[String: Any]) {
        if let progressing = progressContext["isProgressing"] as? Bool {
            if progressing {
                self.taskName = progressContext["title"] as! String
                self.referenceTime = progressContext["referenceTime"] as! Date
                let remainingTime = progressContext["remainingTime"] as! TimeInterval
                self.taskSize = progressContext["taskSize"] as! TimeInterval
                self.taskUri = progressContext["taskUri"] as! String
                self.state = .progressing
                self.targetTime = self.referenceTime.addingTimeInterval(remainingTime)
            }
            else {
                self.state = .notProgressing
                self.taskName = "not progressing"
                self.referenceTime = Date(timeIntervalSince1970: 0)
                self.targetTime = Date(timeIntervalSince1970: 0)
                self.taskSize = 0
                self.taskUri = ""
            }
        } else {
            self.state = .illegalData
            self.taskName = "illegal"
            self.referenceTime = Date(timeIntervalSince1970: 0)
            self.targetTime = Date(timeIntervalSince1970: 0)
            self.taskSize = 0
            self.taskUri = ""
            NSLog("couldn't extract isProgressing from context")
        }
    }
    
    func remainingTime(forDate date: Date) -> TimeInterval {
        return self.targetTime.timeIntervalSince(date)
    }
    
    func calcPercentage(forDate date: Date) -> CGFloat {
        let remainingTime = self.remainingTime(forDate: date)
        guard self.taskSize > 0.0 else {
            return 0.0
        }
        
        let percentage = 1.0 - CGFloat(remainingTime / taskSize)
        return percentage < 0.0 ? 0.0 : (percentage > 1.0 ? 1.0 : percentage)
    }
}
