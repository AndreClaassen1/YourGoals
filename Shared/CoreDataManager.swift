//
//  CoreDataManager.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 21.05.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//
// Important: Shared File between iOS App and WatchKit Extension

import Foundation
import CoreData

class CoreDataManager {
    
    let modelURL:URL
    let databaseName:String
    
    // true, if write ahead logging (WAL-Mode) on sqllite is enabled (default)
    let journalingEnabled: Bool
    
    /// create a new sqlite database with the given name for a bundle
    ///
    /// - Parameters:
    ///   - databaseName: name of the database file
    ///   - modelName: name of the data model
    ///   - bundle: the bundle for storing
    ///   - journalingEnabled: true, if write ahead mode is enabled
    init(databaseName:String, modelName:String, bundle:Bundle, journalingEnabled: Bool) {
        self.databaseName = databaseName
        self.journalingEnabled = journalingEnabled
        self.modelURL = bundle.url(forResource: modelName, withExtension: "momd")!
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.andre.claassen.TestMasterDetail" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        let model = self.modelURL
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        return NSManagedObjectModel(contentsOf: model)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.databaseName)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            var options:[String : Any] = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            // disable write ahead mode for sqlite, if journaling is not enabled
            if !self.journalingEnabled {
                options[NSSQLitePragmasOption] = ["journal_mode" : "DELETE"]
            }
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String : Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    internal func saveContext() throws {
        try self.managedObjectContext.save()
    }
    
}
