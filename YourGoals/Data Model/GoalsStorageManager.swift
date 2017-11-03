//
//  FitnessStorageManager.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 21.05.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// this class handles core data storage of several objects
class GoalsStorageManager {
    
    static let modelName = "GoalsModel"
    static let defaultStorageManager = GoalsStorageManager(databaseName: "GoalsModel.sqlite")
    
    // let goalsStore:StorageBase<Goal>]
    let dataManager:CoreDataManager
    
    let stores:[Storage]
    
    var context:NSManagedObjectContext {
        return dataManager.managedObjectContext
    }
    
    /// inititlaize the class for supporting basic core data operations
    ///
    /// - Parameter dataManager: datamanager class with access to core data storage
    init(dataManager: CoreDataManager) {
        self.dataManager = dataManager
        stores = [
            StorageBase<Goal>(managedObjectContext: dataManager.managedObjectContext, entityName: "Goal"),
            StorageBase<ImageData>(managedObjectContext: dataManager.managedObjectContext, entityName: "ImageData"),
            StorageBase<Task>(managedObjectContext: dataManager.managedObjectContext, entityName: "Task"),
            StorageBase<TaskProgress>(managedObjectContext: dataManager.managedObjectContext, entityName: "TaskProgress")
        ]
    }
    
    func store(id:String) throws -> Storage {
        return stores.first{ $0.storageId() == id }!
    }
    
    var goalsStore:StorageBase<Goal>  {
        return try! store(id: "Goal") as! StorageBase<Goal>
    }

    var imageDataStore:StorageBase<ImageData>  {
        return try! store(id: "ImageData") as! StorageBase<ImageData>
    }

    var tasksStore:StorageBase<Task>  {
        return try! store(id: "Task") as! StorageBase<Task>
    }
    
    var taskProgressStore:StorageBase<TaskProgress> {
        return try! store(id: "TaskProgress") as! StorageBase<TaskProgress>
    }
    
    convenience init(databaseName: String) {
        self.init(dataManager: CoreDataManager(databaseName: databaseName, modelName: GoalsStorageManager.modelName, bundle: Bundle(for: GoalsStorageManager.self)))
    }
    
    func deleteRepository() throws {
        try self.stores.forEach{ try $0.deleteAllEntries() }
        try self.dataManager.saveContext()
    }
}
