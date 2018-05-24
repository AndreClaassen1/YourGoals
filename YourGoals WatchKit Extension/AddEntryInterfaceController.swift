//
//  AddEntryInterfaceController.swift
//  YourGoals WatchKit Extension
//
//  Created by André Claaßen on 18.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class AddEntryInterfaceController: WKInterfaceController {

    @IBOutlet var taskLabel: WKInterfaceLabel!
    var taskDescription = ""
    var session:WCSession!
    var watchActionSender:WatchActionSender!
    
    override func awake(withContext context: Any?) {
        self.session = WCSession.default
        self.watchActionSender = WatchActionSender(session: self.session)
        
        super.awake(withContext: context)
        
        guard  let taskDescription = context as? String else {
            NSLog("couldn't decode task description")
            return
        }
        
        taskLabel.setText(taskDescription)
        self.taskDescription = taskDescription
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func addTaskAction() {
        self.watchActionSender.send(action: .actionAddTask, taskDescription: self.taskDescription)
        self.dismiss()
    }
}
