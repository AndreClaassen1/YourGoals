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
    @IBOutlet var rowBackgroundGroup: WKInterfaceGroup!

    var taskUri:String!
    var watchActionSender:WatchActionSender!
    
    let colorCalculator = ColorCalculator(colors: [UIColor.green, UIColor.yellow, UIColor.red])
    
    func set(watchActionSender:WatchActionSender!, info:WatchTaskInfo) {
        self.taskUri = info.taskUri
        self.watchActionSender = watchActionSender
        self.taskNameLabel.setText(info.taskName)
        self.goalNameLabel.setText(info.goalName)
        self.showProgress(isProgressing: info.isProgressing, percentage: CGFloat(info.percentage))
    }

    @IBAction func taskButtonClicked() {
        self.watchActionSender.send(action: .actionStartTask, taskUri: taskUri, taskDescription: nil)
    }
    
    func showProgress(isProgressing: Bool, percentage:CGFloat) {
        let backGroundColor = isProgressing ? UIColor(red: 0, green: 100, blue: 0, alpha: 0.5) : UIColor.clear
        self.rowBackgroundGroup.setBackgroundColor(backGroundColor)
        let progressColor = self.colorCalculator.calculateColor(percent: percentage)
        let imagePainter = PieProgressPainter()
        let progressImage = imagePainter.draw(percentage: percentage, tintColor: progressColor)
        self.taskImage.setImage(progressImage)
    }
}

