//
//  WatchConnectivity.swift
//  YourGoals
//
//  Created by André Claaßen on 31.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchConnectivityHandler: NSObject, WCSessionDelegate {
    
    var session = WCSession.default
    static var defaultHandler = WatchConnectivityHandler()
    
    override init() {
        super.init()
        session.delegate = self
        session.activate()
        
         NSLog("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
    }
    
    // MARK: - WCSesionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(error)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("didReceiveMessage: %@", message)
        if message["request"] as? String == "date" {
            replyHandler(["date" : "\(Date())"])
        }
    }
}
