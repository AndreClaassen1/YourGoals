//
//  WatchConnectivity.swift
//  YourGoals
//
//  Created by André Claaßen on 31.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchConnectivityHandlerForApp: NSObject, WCSessionDelegate, TaskNotificationProviderProtocol {
    
    var session = WCSession.default
    let progressManager:TaskProgressManager!
    let taskResponder:ActiveTaskResponder!
    let watchTasksContextProvider:WatchTasksContextProvider!
    
    init(observer:TaskNotificationObserver, manager:GoalsStorageManager) {
        self.progressManager = TaskProgressManager(manager: manager)
        self.taskResponder = ActiveTaskResponder(manager: manager)
        self.watchTasksContextProvider = WatchTasksContextProvider(manager: manager)
        super.init()
        session.delegate = self
        session.activate()
        observer.register(provider: self)
        NSLog("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
    }
    
    // MARK: - WCSesionDelegate 
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        updateApplicationContext()
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
            updateApplicationContext()
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
            updateApplicationContext()
        case .actionDone:
            let taskUri = message["taskUri"] as! String
            taskResponder.performAction(action: .done, taskUri: taskUri, forDate: date)
        case .actionNeedMoreTime:
            let taskUri = message["taskUri"] as! String
            taskResponder.performAction(action: .needMoreTime, taskUri: taskUri, forDate: date)
        case .actionStartTask:
            let taskUri = message["taskUri"] as! String
            taskResponder.performAction(action: .startTask, taskUri: taskUri, forDate: date)
        case .actionStopTask:
            let taskUri = message["taskUri"] as! String
            taskResponder.performAction(action: .stopTask, taskUri: taskUri, forDate: date)
        case .actionAddTask:
            guard let taskDescription = message["description"] as? String else {
                NSLog("couldn't receive a task description \(message)")
                return
            }
            
            taskResponder.performAction(action: .addTask, taskDescription: taskDescription, forDate: date)
        }
    }
    
    func progressContext(referenceDate: Date) throws -> [String:Any] {
        guard let task = try progressManager.activeTasks(forDate: referenceDate).first else  {
            return ["isProgressing": false]
        }
        
        let title = task.name ?? "unknown task"
        let remainingTime = task.calcRemainingTimeInterval(atDate: referenceDate)
        let taskSize = task.taskSizeAsInterval()
        
        let context:[String: Any] = [
            "isProgressing": true,
            "title": title,
            "referenceTime" : referenceDate,
            "remainingTime": remainingTime,
            "taskSize": taskSize,
            "taskUri": task.uri
        ]
        
        return context
    }
    
    /// update the application context on the apple watch
    func updateApplicationContext() {
        do {
            let date = Date()
            let progress = try progressContext(referenceDate: date)
            let tasks = try self.watchTasksContextProvider.todayTasks(referenceDate: date, withBackburned: SettingsUserDefault.standard.backburnedGoals)
            
            let tasksContext = tasks.map{ $0.asDictionary }
        
            let applicationContext:[String:Any] = [
                "progress": progress,
                "todayTasks": tasksContext
            ]
            
            try self.session.updateApplicationContext(applicationContext)
        }
        catch let error {
            NSLog("updateApplicationContext error: \(error)")
        }
    }
    
    // MARK: TaskNotificationProviderProtocol
    
    func progressStarted(forTask task: Task, referenceTime: Date) {
        updateApplicationContext()
    }
    
    func progressChanged(forTask task: Task, referenceTime: Date) {
        updateApplicationContext()
    }
    
    func progressStopped() {
        updateApplicationContext()
    }
    
    func tasksChanged() {
        updateApplicationContext()
    }
}
