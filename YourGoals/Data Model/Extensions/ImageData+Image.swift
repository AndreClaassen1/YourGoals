//
//  ImageData+Image.swift
//  YourGoals
//
//  Created by André Claaßen on 24.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension ImageData {
    func setImage(image: UIImage) {
        guard let data = UIImageJPEGRepresentation(image, 0.6) else {
            assertionFailure("couldn't convert image \(image) to jpeg")
            return
        }
        
        self.data = data
    }
}
