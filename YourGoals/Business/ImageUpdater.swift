//
//  File.swift
//  YourGoals
//
//  Created by André Claaßen on 28.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

class ImageUpdater:StorageManagerWorker {
    
    func updateImage(forGoal goal:Goal, image: UIImage?) throws {
        
        let oldImageData = goal.imageData
        
        if let image = image {
            guard let data = UIImageJPEGRepresentation(image, 0.6) else {
                throw GoalError.imageNotJPegError
            }
            
            let imageData = self.manager.imageDataStore.createPersistentObject()
            imageData.data = data
            goal.imageData = imageData
        } else {
            goal.imageData = nil
        }
        
        if oldImageData != nil {
            self.manager.context.delete(oldImageData!)
        }
    }
}
