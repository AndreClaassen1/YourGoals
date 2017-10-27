//
//  NewGoalViewController+ImagePicer.swift
//  YourGoals
//
//  Created by André Claaßen on 26.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension NewGoalViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func configureImagePicker(imagePicker:UIImagePickerController) {
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    func selectImageFromPicker(imagePicker:UIImagePickerController) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            goalImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
