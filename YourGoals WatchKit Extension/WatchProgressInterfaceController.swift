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


enum ProgressInterfaceState {
    case noData
    case illegalData
    case notProgressing
    case progressing
}

class WatchProgressInterfaceController: WKInterfaceController, WCSessionDelegate {
    var session:WCSession!
    
    var state = ProgressInterfaceState.noData
    var title:String!
    var referenceTime:Date!
    var remainingTime:TimeInterval!
    var targetDate:Date!
    var taskSize:TimeInterval!
    var updateTimerForImage:Timer?
    
    @IBOutlet var progressPieImage: WKInterfaceImage!
    @IBOutlet var progressTimer: WKInterfaceTimer!
    @IBOutlet var progressTitleLabel: WKInterfaceLabel!
    
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
        updateProgressingState()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateProgressImage() {
        let imagePainter = PieProgressPainter()
        let remainingTime = targetDate.timeIntervalSince(Date())
        let progressImage = imagePainter.draw(remainingTime: remainingTime, taskSize: taskSize)
        self.progressPieImage.setImage(progressImage)
    }

    @objc func handleTimerEvent() {
        self.updateProgressImage()
    }
    
    func updateProgressingState() {
        updateTimerForImage?.invalidate()
        var hideProgressControls = true
        switch self.state {
        case .noData:
            title = "Waiting for Data ..."
        case .illegalData:
            title = "Error in data transfer"
        case .notProgressing:
            title = "No active task"
        case .progressing:
            hideProgressControls = false
            self.progressTimer.setDate(self.targetDate)
            updateProgressImage()
            updateTimerForImage = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimerEvent), userInfo: nil, repeats: true)
        }
        
        self.progressTimer.setHidden(hideProgressControls)
        self.progressTimer.start()
        self.progressPieImage.setHidden(hideProgressControls)
        self.progressTitleLabel.setText(title)
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
        if let progressing = applicationContext["isProgressing"] as? Bool {
            if progressing {
                self.title = applicationContext["title"] as? String
                self.referenceTime = applicationContext["referenceTime"] as? Date
                self.remainingTime = applicationContext["remainingTime"] as? TimeInterval
                self.taskSize = applicationContext["taskSize"] as? TimeInterval
                
                if self.title != nil && self.referenceTime != nil && self.remainingTime != nil && self.taskSize != nil {
                    self.state = .progressing
                    self.targetDate = self.referenceTime.addingTimeInterval(self.remainingTime)
                } else {
                    NSLog("couldn't extract all needed date out of context: \(applicationContext)")
                }
            } else {
                state = .notProgressing
            }
        } else {
            state = .illegalData
            NSLog("couldn't extract isProgressing from context")
        }
        
        updateProgressingState()
    }
}
