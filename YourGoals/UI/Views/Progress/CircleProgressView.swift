//
//  CircleProgressView.swift
//  YourGoals
//
//  Created by André Claaßen on 01.08.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

/// a view with a circle which displays a little of progress
@IBDesignable class CircleProgressView:UIView {
    
    /// the progress between 0.0 and 1.0
    @IBInspectable var progress:CGFloat = 0.3 {
        willSet(newProgress) {
            assert(newProgress >= 0.0 && newProgress <= 1.0)
        }
        didSet {
            self.circle.strokeEnd = progress
        }
    }
    
    /// the line width of the circlefeiw
    @IBInspectable var lineWidth:CGFloat = 2.0 {
        didSet {
            self.circle.lineWidth = self.lineWidth
            self.circleBackground.lineWidth = self.lineWidth
        }
    }
    
    @IBInspectable var strokeColor = UIColor.green {
        didSet {
            self.circle.strokeColor = self.strokeColor.cgColor
        }
    }
    
    @IBInspectable var backgroundShadowColor = UIColor.lightGray {
        didSet {
            self.circleBackground.strokeColor = self.strokeColor.cgColor
        }
    }
    
    var circle:CAShapeLayer!
    var circleBackground:CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()

    }
    
    func degreesToRadians(angle:CGFloat) -> CGFloat {
        return (angle / 180.0) * .pi
    }
    
    func createCirclePath() -> CGPath {
        let startAngle:CGFloat = degreesToRadians(angle: -90.0)
        let endAngle:CGFloat = degreesToRadians(angle: -90.01)
        let radius = self.frame.height / 2.0 - lineWidth / 2.0
        let centerPoint = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return circlePath.cgPath
    }
    
    /// create two circles with inner and outer progress
    func setupCircleProgressLayers()  {
        let circlePath = createCirclePath()
        circle = CAShapeLayer()
        circle.path = circlePath
        circle.lineCap = .round
        circle.fillColor = UIColor.clear.cgColor
        circle.lineWidth = lineWidth
        circle.strokeColor = strokeColor.cgColor
        circle.zPosition = 1
        circle.strokeEnd = self.progress
        self.layer.addSublayer(circle)
        
        circleBackground = CAShapeLayer()
        circleBackground.path = circlePath
        circleBackground.lineCap = .round
        circleBackground.fillColor = UIColor.clear.cgColor
        circleBackground.lineWidth = lineWidth
        circleBackground.strokeColor = backgroundShadowColor.cgColor
        circleBackground.strokeEnd = 1.0
        circleBackground.zPosition = -1
        self.layer.addSublayer(circleBackground)

    }
    

    override func layoutSubviews() {
        let circlePath = self.createCirclePath()
        self.circle.path = circlePath
        self.circleBackground.path = circlePath
    }
    
    func setupDefaults() {
        setupCircleProgressLayers()
    }
}

