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

class GoalsStorageManager {
    
    static let modelName = "GoalsModel"
    static let defaultStorageManager = GoalsStorageManager(databaseName: "GoalsModel.sqlite")
    
    // let goalsStore:StorageBase<Goal>]
    let dataManager:CoreDataManager
    
    let stores:[Storage]
    
    var context:NSManagedObjectContext {
        return dataManager.managedObjectContext
    }
    
    init(dataManager: CoreDataManager) {
        self.dataManager = dataManager
        stores = [
            StorageBase<Goal>(managedObjectContext: dataManager.managedObjectContext, entityName: "Goal"),
            StorageBase<ImageData>(managedObjectContext: dataManager.managedObjectContext, entityName: "ImageData")
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

    convenience init(databaseName: String) {
        self.init(dataManager: CoreDataManager(databaseName: databaseName, modelName: GoalsStorageManager.modelName, bundle: Bundle(for: GoalsStorageManager.self)))
    }
    
    func deleteRepository() throws {
        try self.stores.forEach{ try $0.deleteAllEntries() }
        try self.dataManager.saveContext()
    }
}
