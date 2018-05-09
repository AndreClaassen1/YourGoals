//
//  UIImage+Grayscale.swift
//  YourGoals
//
//  Created by André Claaßen on 09.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// convert image to gray scale
    ///
    /// - Returns: a gray scaled image
    func convertToGrayScale() -> UIImage? {
        let imageRect:CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        guard let cgImage = self.cgImage else {
            NSLog("no cgImage in image: \(self)")
            return nil
        }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = self.size.width
        let height = self.size.height
        
        // let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            NSLog("couldnt create context")
            return nil
        }
        
        context.draw(cgImage, in: imageRect)
        
        guard let imageRef = context.makeImage() else {
            NSLog("couldn't create a cgimage")
            return nil
        }
        
        let newImage = UIImage(cgImage: imageRef)
        return newImage
    }

}
