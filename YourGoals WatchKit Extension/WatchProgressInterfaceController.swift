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

/// show the progress of the active task on the watch
class WatchProgressInterfaceController: WKInterfaceController, WCSessionDelegate {
    var session:WCSession!
    
    var state = ProgressInterfaceState.noData
    var title:String!
    var referenceTime:Date!
    var targetTime:Date!
    var taskSize:TimeInterval!
    var taskUri:String!
    var updateTimerForImage:Timer?
    var hapticStopAlreadyPlayed = false
    let colorCalculator = ColorCalculator(colors: [UIColor.green, UIColor.yellow, UIColor.red])
    
    @IBOutlet var progressPieImage: WKInterfaceImage!
    @IBOutlet var progressTimer: WKInterfaceTimer!
    @IBOutlet var progressTitleLabel: WKInterfaceLabel!
    @IBOutlet var timeIsOverLabel: WKInterfaceLabel!
    @IBOutlet var needMoreTimeButton: WKInterfaceButton!
    @IBOutlet var doneButton: WKInterfaceButton!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    func sendWatchAction(action: WatchAction, taskUri uri:String?) {
        var userInfo = [String:Any]()

        userInfo["action"] = action.rawValue
        if uri != nil {
            userInfo["taskUri"] = uri
        }
        
        session.sendMessage(userInfo, replyHandler: nil, errorHandler: nil)
    }
    
    func updateProgressPeriodically() {
        updateProgressingState()
        if state == .progressing {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                let remainingTime = self.targetTime.timeIntervalSince(Date())
                self.updateProgressControls(remainingTime: remainingTime)
                if remainingTime < 0.0 {
                    timer.invalidate()
                }
            })
        }
    }
    
    override func didAppear() {
        updateProgressPeriodically()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        session = WCSession.default
        session.delegate = self
        session.activate()
        NSLog("\(session.applicationContext)")
        sendWatchAction(action: .actionActualizeState, taskUri: nil)
        updateProgressingState()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func calcPercentage(remainingTime:TimeInterval, taskSize:TimeInterval) -> CGFloat? {
        if taskSize <= 0.0 {
            NSLog("draw aborted. task size is not valid: \(taskSize)" )
            return nil
        }
        
        let percentage = 1.0 - CGFloat(remainingTime / taskSize)
        
        return percentage < 0.0 ? 0.0 : (percentage > 1.0 ? 1.0 : percentage)
    }

    func updateProgressPieChart(remainingTime: TimeInterval) {
        let percentage = calcPercentage(remainingTime: remainingTime, taskSize: taskSize) ?? 0.0
        let progressColor = self.colorCalculator.calculateColor(percent: percentage)
        let imagePainter = PieProgressPainter()
        let progressImage = imagePainter.draw(percentage: percentage, tintColor: progressColor)
        self.progressPieImage.setImage(progressImage)
    }
    
    func updateProgressControls(remainingTime: TimeInterval) {
        self.needMoreTimeButton.setHidden(false)
        self.doneButton.setHidden(false)
        self.progressPieImage.setHidden(false)
        self.progressTitleLabel.setText(self.title)
        updateProgressPieChart(remainingTime: remainingTime)
        if remainingTime >= 0.0 {
            self.hapticStopAlreadyPlayed  = false
            self.progressTimer.setDate(self.targetTime)
            self.progressTimer.setHidden(false)
            self.timeIsOverLabel.setHidden(true)
            self.progressTimer.start()
        } else {
            self.timeIsOverLabel.setHidden(false)
            self.progressTimer.setHidden(true)
            self.progressTimer.stop()
            self.hapticStop()
        }
    }

    func hapticStop() {
        guard !self.hapticStopAlreadyPlayed else {
            return
        }
        
        WKInterfaceDevice.current().play(.stop)
        self.hapticStopAlreadyPlayed = true
    }
    
    
    func updateProgressingState() {
        updateTimerForImage?.invalidate()
        switch self.state {
        case .noData:
            title = "Waiting for Data ..."
        case .illegalData:
            title = "Error in data transfer"
        case .notProgressing:
            title = "No active task"
        case .progressing:
            let remainingTime = targetTime.timeIntervalSince(Date())
            updateProgressControls(remainingTime: remainingTime)
            return
        }
        
        self.needMoreTimeButton.setHidden(true)
        self.doneButton.setHidden(true)
        self.timeIsOverLabel.setHidden(true)
        self.progressTimer.setHidden(true)
        self.progressPieImage.setHidden(true)
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
                let remainingTime = applicationContext["remainingTime"] as? TimeInterval
                self.taskSize = applicationContext["taskSize"] as? TimeInterval
                self.taskUri = applicationContext["taskUri"] as? String
                
                if self.title != nil && self.referenceTime != nil && remainingTime != nil && self.taskSize != nil {
                    self.state = .progressing
                    // self.targetTime = Date().addingTimeInterval(10.0)
                    self.targetTime = self.referenceTime.addingTimeInterval(remainingTime!)
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
    
    @IBAction func clickedNeedMoreTimeButton() {
        sendWatchAction(action: .actionNeedMoreTime, taskUri: self.taskUri)
    }
    
    @IBAction func clickedDoneButton() {
        sendWatchAction(action: .actionDone, taskUri: self.taskUri)
    }
}
