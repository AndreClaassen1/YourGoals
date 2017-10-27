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
        let inset =  frame.insetBy(dx: 10, dy: 10);
        self.circleChart = PNCircleChart(frame: inset)
        circleChart.total = 1.0
        circleChart.current = 0.0
        circleChart.strokeColor = UIColor(red: 77.0/255.0, green: 186.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        circleChart.lineWidth = 15.0
        circleChart.backgroundColor = calculateColor(fromIndicator: progressIndicator)
        circleChart.displayAnimated = false
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
        
        circleChart.current = NSNumber(value: self.progressInPercent)
        circleChart.backgroundColor = calculateColor(fromIndicator: progressIndicator)
        circleChart.stroke()
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
