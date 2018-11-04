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

/// show the progress of the active task on the watch
class WatchProgressInterfaceController: WKInterfaceController, WatchContextNotification {
    
    var session:WCSession!
    var watchActionSender:WatchActionSender!
    
    var progressingInfo = WatchProgressingInfo()
    
    var updateTimerForImage:Timer?
    var watchHandler:WatchConnectivityHandlerForWatch!
    var hapticStopAlreadyPlayed = false
    let colorCalculator = ColorCalculator(colors: [UIColor.green, UIColor.yellow, UIColor.red])
    
    @IBOutlet var progressPieImage: WKInterfaceImage!
    @IBOutlet var progressTimer: WKInterfaceTimer!
    @IBOutlet var progressTitleLabel: WKInterfaceLabel!
    @IBOutlet var timeIsOverLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.watchHandler = WatchConnectivityHandlerForWatch.defaultHandler
        self.watchHandler.registerDelegate(delegate: self)
        self.watchHandler.activate()
        
        // Configure interface objects here.
    }
    
    func updateProgressPeriodically() {
        updateProgressingState()
        if self.progressingInfo.state == .progressing {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.updateProgressControls(forDate: Date())
                if self.progressingInfo.remainingTime(forDate: Date()) < 0.0 {
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
        
        self.session = WCSession.default
        self.watchActionSender = WatchActionSender(session: self.session)
        
        self.watchActionSender.send(action: .actionActualizeState, taskUri: nil)
        updateProgressingState()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    

    func updateProgressPieChart(forDate date:Date) {
        let percentage = self.progressingInfo.calcPercentage(forDate: date)
        let progressColor = self.colorCalculator.calculateColor(percent: percentage)
        let imagePainter = PieProgressPainter()
        let progressImage = imagePainter.draw(percentage: percentage, tintColor: progressColor)
        self.progressPieImage.setImage(progressImage)
    }
    
    func updateProgressControls(forDate date:Date) {
        self.progressPieImage.setHidden(false)
        self.progressTitleLabel.setText(self.progressingInfo.taskName )
        
        
        updateProgressPieChart(forDate: date)
        if self.progressingInfo.remainingTime(forDate: date) >= 0.0 {
            self.hapticStopAlreadyPlayed  = false
            self.progressTimer.setDate(self.progressingInfo.targetTime)
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
        var title = ""
        switch self.progressingInfo.state {
        case .noData:
            title = "Waiting for Data ..."
        case .illegalData:
            title = "Error in data transfer"
        case .notProgressing:
            title = "No active task"
        case .progressing:
            title = self.progressingInfo.taskName
            updateProgressControls(forDate: Date())
            return
        }
        
        self.timeIsOverLabel.setHidden(true)
        self.progressTimer.setHidden(true)
        self.progressPieImage.setHidden(true)
        self.progressTitleLabel.setText(title)
    }

    
    @IBAction func menuAddItem() {
        #if targetEnvironment(simulator)
            let testInput = ["Test entry 1", "Test entry 2", "Test entry 3" ]
        #else
            let testInput = [String]()
        #endif
        
        self.presentTextInputController(withSuggestions: testInput, allowedInputMode: .plain) {
            results in
            
            guard let userInput = results?[0] as? String else { return }
            self.presentController(withName: "AddEntryInterfaceController", context: userInput )
        }
    
    }
    
    @IBAction func menuNeedMoreTime() {
        self.watchActionSender.send(action: .actionNeedMoreTime, taskUri: self.progressingInfo.taskUri)
    }
    
    @IBAction func menuDone() {
        self.watchActionSender.send(action: .actionDone, taskUri: self.progressingInfo.taskUri)
    }
    
    @IBAction func menuPauseTask() {
        self.watchActionSender.send(action: .actionStopTask, taskUri: self.progressingInfo.taskUri)
    }
    
    // MARK: WatchContextNotification
    
    func progressContextReceived(progressContext: [String: Any]) {
        self.progressingInfo = WatchProgressingInfo(fromContext: progressContext)
        
        updateProgressingState()
    }
    
    func todayTasksReceived(tasks: [WatchTaskInfo]) {
        
    }    
}
