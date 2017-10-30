//
//  ProgressIndicatorView.swift
//  YourGoals
//
//  Created by André Claaßen on 27.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import PNChart

class ProgressIndicatorView: UIView {

    var progressInPercent = 0.0
    var progressIndicator:ProgressIndicator = ProgressIndicator.notStarted
    var circleChart:PNCircleChart!
    var label:UILabel!
    
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
    }
    
    func createCirle() {
        let circleFrame = CGRect(x: 5.0, y: 5.0, width: self.frame.width - 10.0, height: self.frame.height - 10.0)
        self.circleChart = PNCircleChart(frame: circleFrame, total: 1.0, current: NSNumber(value: self.progressInPercent), clockwise: true)
        circleChart.strokeColor = calculateColor(fromIndicator: self.progressIndicator)
        circleChart.lineWidth = 55.0
        circleChart.backgroundColor = UIColor.clear
        circleChart.displayAnimated = true
        self.addSubview(self.circleChart)
        
        let labelSize = CGSize(width: 100, height: 21)
        let x = (frame.width - labelSize.width) / 2
        let y = (frame.height - labelSize.height) / 2
        self.label = UILabel(frame: CGRect(x: x, y: y, width: labelSize.width, height: labelSize.height))
        self.addSubview(self.label)
    }

    func setProgress(progressInPercent:Double, progressIndicator:ProgressIndicator) {
        self.progressInPercent = progressInPercent
        self.progressIndicator = progressIndicator
        if self.circleChart == nil {
            self.createCirle()
        } else {
            self.circleChart.strokeColor = calculateColor(fromIndicator: self.progressIndicator)
            self.circleChart.update(byCurrent: NSNumber(value: self.progressInPercent))
        }
    }
    
    func setProgress(forGoal goal:Goal) {
        let calculator = GoalProgressCalculator()
        let progress = calculator.calculateProgress(forGoal: goal, forDate: Date())
        
        self.setProgress(progressInPercent: progress.progressInPercent, progressIndicator: progress.indicator)
    }
    
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
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        circleChart.stroke()
    }
}
