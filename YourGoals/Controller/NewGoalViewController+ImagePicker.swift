//
//  NewGoalViewController+ImagePicer.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension NewGoalViewController : UIImagePickerControllerDelegate {
    
    func configureImagePicker(imagePicker:UIImagePickerController) {
        imagePicker.delegate = self
    }
    
    func selectImageFromPicker(imagePicker:UIImagePickerController) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            goalImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
