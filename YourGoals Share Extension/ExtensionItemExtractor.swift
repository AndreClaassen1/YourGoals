//
//  ExtensionItemExtractor.swift
//  YourGoals Share Extension
//
//  Created by André Claaßen on 11.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import CoreGraphics

/// helper class to extract the content of the extension dialog
public class ExtensionItemExtractor {
    
    public init() {
        
    }
    
    func marshalImageInBackground(_ attachment: NSItemProvider, callback:  @escaping (UIImage)->Void) {
        // Marshal on to a background thread
        
        DispatchQueue.global().async {
            attachment.loadItem(forTypeIdentifier: kUTTypeImage as NSString as String, options: nil) {
                (imageProvider, error) -> Void in
                
                guard imageProvider !=  nil else  {
                    NSLog("no imageProvider available?")
                    return
                }
                
                var image:UIImage? = nil
                
                if imageProvider is UIImage {
                    image = imageProvider as? UIImage
                }
                
                if imageProvider is NSURL {
                    let data = try? Data(contentsOf: imageProvider as! URL)
                    image = UIImage(data: data!)!
                }
                
                if let image = image {
                    // pass the scaled down image on the main thread
                    DispatchQueue.main.async {
                        callback(image)
                    }
                }
            }
        }
    }
    
    func imageFromExtensionItem(_ extensionItem: NSExtensionItem, callback: @escaping (UIImage)->Void) {
        for attachment in extensionItem.attachments as! [NSItemProvider] {
            if(attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as String)) {
                marshalImageInBackground(attachment, callback: callback)
            }
        }
    }
    
    
    func urlFromExtensionItem(_ extensionItem: NSExtensionItem, callback: @escaping (String)->Void) {
        //get the itemProvider which wraps the url we need
        
        if let itemProvider = extensionItem.attachments?[0] as? NSItemProvider {
            
            //pull the URL out
            if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) {
                    (urlItem, error) in
                    
                    let urlString = (urlItem as! URL).absoluteString
                    callback(urlString)
                }
            }
        }
    }
}
