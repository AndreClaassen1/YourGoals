//
//  StorageManagerBase.swift
//  YourGoals
//
//  Created by André Claaßen on 11.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

/// base class to reuse some code for StorageManager classes
open class StorageManagerBase {
    
    // let goalsStore:StorageBase<Goal>]
    let dataManager:CoreDataManager
    
    /// the stores for several typed entities
    let stores:[Storage]
    
    /// the managed data context
    public var context:NSManagedObjectContext {
        return dataManager.managedObjectContext
    }
    
    /// initialize the storage manager class with datamanager and storage classes for
    /// the entities in the data model
    ///
    /// - Parameters:
    ///   - dataManager: the data manager
    ///   - stores: array of storage classes
    public init(dataManager:CoreDataManager, stores:[Storage]) {
        self.dataManager = dataManager
        self.stores = stores
    }
    
    /// retrieve a core data entity storage with the id which is identical with the entityname
    ///
    /// - Parameter id: id is the entity name of the storage
    /// - Returns: the storage
    /// - Throws: core data exception
    public func store(id:String) throws -> Storage {
        return stores.first{ $0.storageId() == id }!
    }
    
    /// save all changed objects to the core data store
    ///
    /// - Throws: core data exception
    public func saveContext() throws {
        try self.dataManager.saveContext()
    }
    
    /// delete all entity objects from the database
    ///
    /// - Throws: core data exception
    public func deleteRepository() throws {
        try self.dataManager.saveContext()
        try self.stores.forEach{ try $0.deleteAllEntries() }
        try self.dataManager.saveContext()
    }
}
