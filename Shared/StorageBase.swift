//
//  StorageBase.swift
//  YourDay
//
//  Created by Andre Claaßen on 02.11.14.
//  Copyright (c) 2014 Andre Claaßen. All rights reserved.
//
// Important: Shared File between iOS App and WatchKit Extension

import Foundation
import CoreData

protocol Storage {
    func storageId() -> String
    func deleteAllEntries() throws
}

/// Base class for core data storage operations for one or more entities
public class StorageBase<T:NSManagedObject> : Storage {
    public let entityName:String
    public let managedObjectContext:NSManagedObjectContext
    
    private class func getEntityName() -> String {
        let managedObject = T()
        return managedObject.entity.name!
    }
    
    public init(managedObjectContext:NSManagedObjectContext, entityName:String) {
        self.entityName = entityName
        self.managedObjectContext = managedObjectContext
    }
    
    public func storageId() -> String {
        return self.entityName
    }
        
    public func createPersistentObject() -> T {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext) as! T
    }
    
    public func createPersistentObject(entityName:String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext) as NSManagedObject
    }
    
    public func retrieveExistingObject(objectId:NSManagedObjectID) -> T {
        let obj = try! self.managedObjectContext.existingObject(with: objectId)
        return obj as! T
    }

    public func getEntityDescription(entity:String?=nil) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entity == nil ? self.entityName: entity!, in: self.managedObjectContext)!
    }
    
    
    public func createFetchRequestForEntity(entity:String?=nil) -> NSFetchRequest<T> {
        let request = NSFetchRequest<T>()
        request.entity = getEntityDescription(entity: entity)
        return request
    }
    
    public func fetchFirstEntry(qualifyRequest:((NSFetchRequest<T>)->Void)? = nil) throws -> T? {
        let request = createFetchRequestForEntity()
        if qualifyRequest != nil {
            qualifyRequest!(request)
        }
        
        request.fetchLimit = 1
        let items: [AnyObject]? = try self.managedObjectContext.fetch(request)
        if items!.count == 0 {
            return nil
        }
        
        return items![0] as? T
    }
    
    /**
     countEntries - Counts the number of entries you would fetch, if you would invoke fetchEntries
     
     - parameter qualifyRequest: the block to qualify the fetch reques
     
     - returns: the number of counted entries
     */
    public func countEntries(qualifyRequest:(NSFetchRequest<T>)->Void) throws -> Int {
        let request = createFetchRequestForEntity()
        qualifyRequest(request)
        
        let countItems = try self.managedObjectContext.count(for: request)
        
        return countItems
    }
    
    func fetchItems(entity:String? = nil, qualifyRequest:(NSFetchRequest<T>)->Void) throws -> [T] {
        let request = createFetchRequestForEntity(entity: entity)
        qualifyRequest(request)
        
        return try self.managedObjectContext.fetch(request)
    }

    public func fetchEntries(qualifyRequest:(NSFetchRequest<T>)->Void) throws -> [T] {
        return try fetchItems(qualifyRequest: qualifyRequest)
    }

    public func fetchAllEntries() throws -> [T] {
        let request = createFetchRequestForEntity(entity: nil)
        return try self.managedObjectContext.fetch(request)
    }

    public func deleteEntries(qualifyRequest:(NSFetchRequest<T>)->Void) throws {
        let items = try self.fetchEntries(qualifyRequest: qualifyRequest)
        
        for managedObject in items {
            self.managedObjectContext.delete(managedObject)
        }

    }
    
    public func deleteAllEntries() throws {
        let request = createFetchRequestForEntity(entity: nil)
        let items =  try self.managedObjectContext.fetch(request)

        for managedObject in items {
            self.managedObjectContext.delete(managedObject)
        }

    }
    
    public func flush() throws {
        if self.managedObjectContext.hasChanges {
            try self.managedObjectContext.save()
        }
        self.managedObjectContext.reset()
    }

    public func deleteEntriesForEntity(entity: String, qualifyRequest:(NSFetchRequest<T>)->Void) throws {
        let items = try self.fetchItems(entity: entity, qualifyRequest: qualifyRequest) 
        
        for managedObject in items {
            self.managedObjectContext.delete(managedObject)
        }
    }
}