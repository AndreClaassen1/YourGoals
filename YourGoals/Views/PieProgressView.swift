//
//  PieChart.swift
//  YourGoals
//
//  Created by André Claaßen on 22.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PieProgressView:UIView {
    
    // Mark : - Inspectable

    /// The color of the empty progress track (gets drawn over)
    @IBInspectable open var trackTintColor: UIColor {
        get {
            return progressLayer.trackTintColor
        }
        set {
            progressLayer.trackTintColor = newValue
            progressLayer.setNeedsDisplay()
        }
    }

    /// progress bar color
    @IBInspectable open var progressTintColor: UIColor {
        get {
            return progressLayer.progressTintColor
        }
        set {
            progressLayer.progressTintColor = newValue
            progressLayer.setNeedsDisplay()
        }
    }

    /// fill bar color
    @IBInspectable open var fillColor: UIColor {
        get {
            return progressLayer.fillColor
        }
        set {
            progressLayer.fillColor = newValue
            progressLayer.setNeedsDisplay()
        }
    }
    ///  current progress (not observed from any active animations)
    @IBInspectable open var progress: CGFloat {
        get {
            return progressLayer.progress
        }
        set {
            progressLayer.progress = newValue
            progressLayer.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if let window = window {
            progressLayer.contentsScale = window.screen.scale
            progressLayer.setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        self.layer.setNeedsDisplay()
    }
    
    func setupDefaults() {
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: - Custom Base Layer
    
    fileprivate var progressLayer: ProgressLayer! {
        get {
            return layer as! ProgressLayer
        }
    }
    
    open override class var layerClass : AnyClass {
        return ProgressLayer.self
    }
    
}

class ProgressLayer: CALayer {
    
    // This needs to have a setter/getter for it to work with CoreAnimation, therefore NSManaged
    var progress:CGFloat = 0.3
    var thicknessRatio: CGFloat = 0.1
    var progressTintColor = UIColor.blue
    var trackTintColor = UIColor.blue
    var fillColor = UIColor.blue.withAlphaComponent(0.3)
    
    func fillProgressIfNecessary(ctx: CGContext, centerPoint:CGPoint, radius:CGFloat, radians:CGFloat) {
        guard progress >= 0.0 else {
            return
        }
        
        ctx.setFillColor(progressTintColor.cgColor)
        let progressPath = CGMutablePath()
        progressPath.move(to: centerPoint)
        progressPath.addArc(center: centerPoint, radius: radius, startAngle: CGFloat(3 * (Double.pi / 2)), endAngle: radians, clockwise: false)
        progressPath.closeSubpath()
        ctx.addPath(progressPath)
        ctx.fillPath()
    }

    func fillBackgroundCircle(ctx:CGContext, centerPoint:CGPoint, radius:CGFloat) {
        let rect = CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: radius * 2, height: radius * 2)
        
        ctx.setFillColor(self.fillColor.cgColor)
        ctx.fillEllipse(in: rect)
    }
    
    func fillOuterCircle(ctx:CGContext, centerPoint:CGPoint, radius:CGFloat) {
        let lineWidth = thicknessRatio * radius
        let rect = CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: radius * 2, height: radius * 2).insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0 )
        
        ctx.setStrokeColor(trackTintColor.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.strokeEllipse(in: rect)
    }
    
    override func draw(in ctx: CGContext) {
        let rect = bounds
        let centerPoint = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = min(rect.size.height, rect.size.width) / 2
        let progressRadius = radius * (1 - thicknessRatio * 2.0)
        
        let progress: CGFloat = min(self.progress, CGFloat(1 - Float.ulpOfOne))
        
        // clockwise progress
        let radians = CGFloat((Double(progress) * 2 * Double.pi) - (Double.pi / 2))
        
        fillProgressIfNecessary(ctx: ctx, centerPoint: centerPoint, radius: progressRadius, radians: radians)
        fillBackgroundCircle(ctx: ctx, centerPoint: centerPoint, radius: radius)
        fillOuterCircle(ctx: ctx, centerPoint: centerPoint, radius: radius)
    }
}
