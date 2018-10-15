//
//  ShareViewController.swift
//  YourGoals Share Extension
//
//  Created by André Claaßen on 10.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit
import Social
import YourGoalsKit

/// the default share view controller for easy creating a new task
class ShareViewController: SLComposeServiceViewController {
    var attachedImage: UIImage?
    var attachedUrl: String?
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    /// initialize the controller
    override func presentationAnimationDidFinish() {
        
        let extractor = ExtensionItemExtractor()
        // Only interested in the first item
        
        guard let extensionItem = extensionContext?.inputItems[0] as? NSExtensionItem else {
            NSLog("couldn't get the extensionItem.")
            return
        }
        
        // Extract an image, if available and consumable
        extractor.imageFromExtensionItem(extensionItem) {
            self.attachedImage = $0
        }
        
        // extract an url, if available.
        extractor.urlFromExtensionItem(extensionItem) {
            self.attachedUrl = $0
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Your Goals", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// post the selected content to the journal infio store
    override func didSelectPost() {
        do {
            guard !self.contentText.isEmpty else {
                showAlert(message: "I need some text for a new task")
                return
            }
            
            let manager = ShareStorageManager.defaultStorageManager
            let provider = ShareExtensionTasksProvider(manager: manager)
            try provider.saveNewTaskFromExtension(name: self.contentText, urlString: self.attachedUrl, image: self.attachedImage )
        } catch let error {
            self.showAlert(message: error.localizedDescription)
        }
    }

}
