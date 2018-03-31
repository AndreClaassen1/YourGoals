//
//  InterfaceController.swift
//  YourGoals WatchKit Extension
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ActionableInterfaceController: WKInterfaceController, WCSessionDelegate {
    var session:WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // MARK: WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("activationDidCompleteWith activationState: \(activationState)")
    }
    
    /// process the new application context from the host
    ///
    /// - Parameters:
    ///   - session: the session
    ///   - applicationContext: the application context
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
}
