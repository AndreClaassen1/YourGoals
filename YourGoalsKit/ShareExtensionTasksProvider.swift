//
//  ShareExtensionTasksProvider.swift
//  YourGoalsKit
//
//  Created by André Claaßen on 11.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

enum ShareExtensionError : Error {
    case taskNameNeeded
}


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
    
    /// save a new task request from a shared extenison in a buffer storage
    ///
    /// - Parameters:
    ///   - name: name of the new task
    ///   - url: an optional url
    ///   - image: an optional image
    /// - Throws: core data exception
    public func saveNewTaskFromExtension(name: String, url: String?, image:UIImage?) throws {
        let shareNewTask = manager.shareNewTaskStore.createPersistentObject()
        
        guard !name.isEmpty else {
            throw ShareExtensionError.taskNameNeeded
        }
        
        shareNewTask.taskname = name
        shareNewTask.image = image?.jpegData(compressionQuality: 0.7)
        shareNewTask.url = url
        try manager.saveContext()
    }
    
    /// consume all data from the share extension
    ///
    /// - Parameter consume: function to process the shared task
    /// - Throws: exception
    public func consumeNewTasksFromExtension(consume: (ShareNewTask) throws -> () ) throws {
        let newTasks = try self.manager.shareNewTaskStore.fetchAllEntries()
        for task in newTasks {
            guard task.taskname != nil && !task.taskname!.isEmpty else {
                continue
            }
            
            try consume(task)
            self.manager.context.delete(task)
        }
        
        try self.manager.saveContext()
    }
}
