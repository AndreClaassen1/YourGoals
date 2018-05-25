//
//  TodayInterfaceController.swift
//  YourGoals WatchKit Extension
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class TodayInterfaceController: WKInterfaceController, WatchContextNotification {
    
    @IBOutlet var tasksTable: WKInterfaceTable!
    
    let watchActionSender = WatchActionSender(session: WCSession.default)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        WatchConnectivityHandlerForWatch.defaultHandler.registerDelegate(delegate: self)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: WatchContextNotification
    
    func progressContextReceived(progressContext: [String : Any]) {
        
    }
    
    func todayTasksReceived(tasks: [WatchTaskInfo]) {
        tasksTable.setNumberOfRows(tasks.count, withRowType: "taskRowController")
        for tuple in tasks.enumerated() {
            let taskRowController = tasksTable.rowController(at: tuple.offset) as! WatchTaskRowController
            taskRowController.set(watchActionSender: self.watchActionSender, info: tuple.element)
        }
    }
}
