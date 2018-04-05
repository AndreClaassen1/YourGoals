//
//  PieProgressPainter.swift
//  YourGoals
//
//  Created by André Claaßen on 03.04.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchKit

class PieProgressPainter {
    let chartSize = CGSize(width: 312, height: 200)
    let bounds:CGRect!
    
    
    init() {
        self.bounds = CGRect(x: 0, y: 0, width: chartSize.width, height: chartSize.height)
    }
    
    
    // This needs to have a setter/getter for it to work with CoreAnimation, therefore NSManaged
    var thicknessRatio: CGFloat = 0.1
    var progressTintColor = UIColor.blue
    var trackTintColor = UIColor.blue
    var fillColor = UIColor.blue.withAlphaComponent(0.3)
    var clockwise = true
    
    func fillProgressIfNecessary(ctx: CGContext, progress:CGFloat, centerPoint:CGPoint, radius:CGFloat, radians:CGFloat) {
        guard progress >= 0.0 else {
            return
        }
        
        ctx.setFillColor(progressTintColor.cgColor)
        let progressPath = CGMutablePath()
        progressPath.move(to: centerPoint)
        let topAngle = CGFloat(3 * (Double.pi / 2))
        
        if clockwise {
            progressPath.addArc(center: centerPoint, radius: radius, startAngle: topAngle, endAngle: radians, clockwise: false )
        } else {
            progressPath.addArc(center: centerPoint, radius: radius, startAngle: radians, endAngle: topAngle, clockwise: true)
        }
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
    
    func draw(in ctx: CGContext, percentage:CGFloat) {
        let rect = self.bounds!
        let centerPoint = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = min(rect.size.height, rect.size.width) / 2
        let progressRadius = radius * (1 - thicknessRatio * 2.0)
        let progress: CGFloat = min(percentage, CGFloat(1 - Float.ulpOfOne))
        
        // clockwise progress
        let radians = clockwise ?
            CGFloat((Double(progress) * 2.0 * Double.pi) - (Double.pi / 2)) :
            CGFloat( 2.0 * Double.pi - (Double(progress) * 2.0 * Double.pi) - (Double.pi / 2.0))
        
        fillProgressIfNecessary(ctx: ctx, progress: progress, centerPoint: centerPoint, radius: progressRadius, radians: radians)
        fillBackgroundCircle(ctx: ctx, centerPoint: centerPoint, radius: radius)
        fillOuterCircle(ctx: ctx, centerPoint: centerPoint, radius: radius)
    }
    
    func draw(percentage: CGFloat, tintColor: UIColor) -> UIImage? {
        self.progressTintColor = tintColor
        self.trackTintColor = tintColor
        self.fillColor = tintColor.withAlphaComponent(0.3)
        
        UIGraphicsBeginImageContext(chartSize)
        let context = UIGraphicsGetCurrentContext()!
        draw(in: context, percentage: percentage)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}
