//
//  WatchTaskRowController.swift
//  YourGoals WatchKit Extension
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchKit

class WatchTaskRowController:NSObject {
    @IBOutlet var taskImage: WKInterfaceImage!
    @IBOutlet var taskNameLabel: WKInterfaceLabel!
    @IBOutlet var goalNameLabel: WKInterfaceLabel!
    var taskUri:String!
    var watchActionSender:WatchActionSender!
    
    let colorCalculator = ColorCalculator(colors: [UIColor.green, UIColor.yellow, UIColor.red])
    
    func set(watchActionSender:WatchActionSender!, info:WatchTaskInfo) {
        self.taskUri = info.taskUri
        self.watchActionSender = watchActionSender
        self.taskNameLabel.setText(info.taskName)
        self.goalNameLabel.setText(info.goalName)
        self.showProgress(percentage: CGFloat(info.percentage))
    }

    @IBAction func taskButtonClicked() {
        self.watchActionSender.send(action: .actionStartTask, taskUri: taskUri, taskDescription: nil)
    }
    
    func showProgress(percentage:CGFloat) {
        let progressColor = self.colorCalculator.calculateColor(percent: percentage)
        let imagePainter = PieProgressPainter()
        let progressImage = imagePainter.draw(percentage: percentage, tintColor: progressColor)
        self.taskImage.setImage(progressImage)
    }
}

