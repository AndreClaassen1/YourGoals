//
//  ProgressIndicatorView.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import PNChart

enum ProgressIndicatorViewMode {
    case normal
    case mini
}

/// a circle progress indicator
class ProgressIndicatorView: UIView {
    var viewMode = ProgressIndicatorViewMode.normal
    var progressView:PieProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clear
        self.progressView = PieProgressView(frame: self.bounds)
        self.addSubview(progressView)
    }
    
    func setProgress(progress:Double, progressIndicator:ProgressIndicator) {
        let color = calculateColor(fromIndicator: progressIndicator)
        self.progressView.progressTintColor = color
        self.progressView.trackTintColor = color
        self.progressView.fillColor = color.withAlphaComponent(0.3)
        self.progressView.progress = CGFloat(progress)
    }
    
    /// show the progress of the goal as a colored circle

    /// - Parameters:
    ///   - goal: the goal
    ///   - date: calculation of progress for this date
    ///   - manager: a manager to retrieve actual data from the core data sotre
    /// - Throws: core data exception
    func setProgress(forGoal goal:Goal, forDate date: Date, withBackburned backburnedGoals:Bool, manager: GoalsStorageManager) throws {
        let calculator = GoalProgressCalculator(manager: manager)
        let progress = try calculator.calculateProgress(forGoal: goal, forDate: date, withBackburned: backburnedGoals)
        self.setProgress(progress: progress.progress, progressIndicator: progress.indicator)
    }
    
    /// convert the progress indicator to a traffic color
    ///
    /// - Parameter progressIndicator: the progress indicator
    /// - Returns: a color represnetation the state of the progress
    func calculateColor(fromIndicator progressIndicator: ProgressIndicator) -> UIColor {
        switch progressIndicator {
        case .met:
            return UIColor.green
            
        case .ahead:
            return UIColor.blue
            
        case .onTrack:
            return UIColor.green
            
        case .lagging:
            return UIColor.orange
            
        case .behind:
            return UIColor.red
            
        case .notStarted:
            return UIColor.lightGray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
