//
//  WatchConnectivityHandlerForWatch.swift
//  YourGoals WatchKit Extension
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

protocol WatchContextNotification {
    func progressContextReceived(progressContext: [String:Any])
    func todayTasksReceived(tasks:[WatchTaskInfo])
}


class WatchConnectivityHandlerForWatch : NSObject, WCSessionDelegate {
    
    let session:WCSession!
    var delegates = [WatchContextNotification]()
    
    static let defaultHandler = WatchConnectivityHandlerForWatch(session: WCSession.default)
    
    init (session:WCSession) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func registerDelegate(delegate: WatchContextNotification) {
        self.delegates.append(delegate)
    }
    
    func activate() {

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
        guard let progressContext = applicationContext["progress"] as? [String: Any] else {
            NSLog("coulnd't extract progess context from application context: \(applicationContext)" )
            return
        }

        for delegate in delegates {
            delegate.progressContextReceived(progressContext: progressContext)
        }

        
        guard let todayTasksContext = applicationContext["todayTasks"] as? [[String: Any]] else {
            NSLog("couldn't extract today tasks from application context: \(applicationContext)")
            return
        }
        
        let todayTasks = todayTasksContext.map { WatchTaskInfo(fromDictionary: $0) }
        
        for delegate in delegates {
            delegate.todayTasksReceived(tasks: todayTasks)
        }
    }
}
