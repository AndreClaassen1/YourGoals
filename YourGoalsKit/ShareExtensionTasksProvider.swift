//
//  ShareExtensionTasksProvider.swift
//  YourGoalsKit
//
//  Created by André Claaßen on 11.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// class for saving new tasks from the share extension and consume then
public class ShareExtensionTasksProvider {
    
    /// a core data storage manager
    let manager:ShareStorageManager
    
    /// initialize this class with a core data storage manager
    ///
    /// - Parameter manager: a core data storage manager
    public init(manager: ShareStorageManager) {
        self.manager = manager
    }
    
    /// create a new task from a shared extenison
    ///
    /// - Parameters:
    ///   - name: name of the new task
    ///   - url: an optional url
    ///   - image: an optional image
    /// - Throws: core data exception
    public func saveNewTaskFromExtension(name: String, url: URL?, image:UIImage?) throws {
        let shareNewTask = manager.shareNewTaskStore.createPersistentObject()
        shareNewTask.image = image?.jpegData(compressionQuality: 0.7)
        shareNewTask.url = url?.absoluteString
        try manager.saveContext()
    }
    
    /// consume all data from the share extension
    ///
    /// - Parameter consume: function to process the shared task
    /// - Throws: exception
    public func consumeNewTasksFromExtension(consume: (ShareNewTask) -> () ) throws {
        let newTasks = try self.manager.shareNewTaskStore.fetchAllEntries()
        for task in newTasks {
            consume(task)
            self.manager.context.delete(task)
        }
        
        try self.manager.saveContext()
    }
}
