//
//  WatchConnectivity.swift
//  YourGoals
//
//  Created by André Claaßen on 31.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchConnectivityHandler: NSObject, WCSessionDelegate, TaskNotificationProviderProtocol {
    
    var session = WCSession.default
    let progressManager:TaskProgressManager!
    let taskResponder:ActiveTaskResponder!
    
    init(observer:TaskNotificationObserver, manager:GoalsStorageManager) {
        self.progressManager = TaskProgressManager(manager: manager)
        self.taskResponder = ActiveTaskResponder(manager: manager)
        super.init()
        session.delegate = self
        session.activate()
        observer.register(provider: self)
        NSLog("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
    }
    
    // MARK: - WCSesionDelegate 
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        updateContextWithState()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
        if session.activationState == .activated {
            updateContextWithState()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("didReceiveMessage with reply: %@", message)
        if message["request"] as? String == "date" {
            replyHandler(["date" : "\(Date())"])
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        NSLog("didReceiveMessage without reply: %@", message)
        guard let actionStr = message["action"] as? String else {
            NSLog("couldn't extract action")
            return
        }
        
        guard let actionType = WatchAction(rawValue: actionStr) else {
            NSLog("session error: couldn't extract action token")
            return
        }
        
        let date = Date()
        
        switch actionType {
        case .actionActualizeState:
            updateContextWithState()
        case .actionDone:
            let taskUri = message["taskUri"] as! String
            taskResponder.performAction(taskUri: taskUri, action: .done, forDate: date)
        case .actionNeedMoreTime:
            let taskUri = message["taskUri"] as! String
            taskResponder.performAction(taskUri: taskUri, action: .needMoreTime, forDate: date)
        }
    }
    
    func updateContextWithProgress(forTask task:Task, referenceTime: Date) {
        let title = task.name ?? "unknown task"
        let remainingTime = task.calcRemainingTimeInterval(atDate: referenceTime)
        let taskSize = task.taskSizeAsInterval()
        
        let context:[String: Any] = [
            "isProgressing": true,
            "title": title,
            "referenceTime" : referenceTime,
            "remainingTime": remainingTime,
            "taskSize": taskSize,
            "taskUri": task.objectID.uriRepresentation().absoluteString
        ]
        
        do{
            try self.session.updateApplicationContext(context)
        }
        catch let error {
            NSLog("transmitting application context failed with: \(error)")
        }
    }
    
    func updateContextWithNoProgress() {
        let context:[String: Any] = [
            "isProgressing": false
        ]
        
        do{
            try self.session.updateApplicationContext(context)
        }
        catch let error {
            NSLog("transmitting application context failed with: \(error)")
        }
    }
    
    func updateContextWithState() {
        do {
            let referenceDate = Date()
            if let activeTask = try progressManager.activeTasks(forDate: referenceDate).first {
                updateContextWithProgress(forTask: activeTask, referenceTime: referenceDate )
            } else {
                updateContextWithNoProgress()
            }
        }
        catch let error {
            NSLog("updateContextWithState error: \(error)")
        }
    }
    
    // MARK: TaskNotificationProviderProtocol
    
    
    func progressStarted(forTask task: Task, referenceTime: Date) {
        updateContextWithProgress(forTask: task, referenceTime: referenceTime)
    }
    
    func progressChanged(forTask task: Task, referenceTime: Date) {
        updateContextWithProgress(forTask: task, referenceTime: referenceTime)
    }
    
    func progressStopped() {
        updateContextWithNoProgress()
    }
    
}
