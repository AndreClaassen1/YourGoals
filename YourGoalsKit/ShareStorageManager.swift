//
//  ShareStorageManager.swift
//  YourGoalsKit
//
//  Created by André Claaßen on 11.10.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import CoreData

/// this class handels the data model of files needed for the share extension
/// the data is located in the app group container
public class ShareStorageManager : StorageManagerBase  {
    static let applicationGroupName = "group.com.yourgoals.app"
    static let modelName = "GoalsShareModel"
    static let defaultStorageManager = ShareStorageManager(databaseName: "GoalsShareModel.sqlite")
    
    /// inititlaize the class for supporting basic core data operations
    ///
    /// - Parameter dataManager: datamanager class with access to core data storage
    init(dataManager: CoreDataManager) {
        super.init(dataManager: dataManager, stores: [
            StorageBase<ShareNewTask>(managedObjectContext: dataManager.managedObjectContext, entityName: "ShareNewTask")])
    }
    
    /// convinience initializer
    ///
    /// - Parameters:
    ///   - databaseName: database file name
    ///   - journalingEnabled: true, if journaling is enabled (default)
    convenience init(databaseName: String, journalingEnabled: Bool = true) {
        self.init(dataManager: CoreDataManager(databaseName: databaseName, modelName: ShareStorageManager.modelName, bundle: Bundle(for: ShareStorageManager.self),
                                               groupName: ShareStorageManager.applicationGroupName,
                                               journalingEnabled: journalingEnabled))
    }
    
    /// access the share new task store
    var shareNewTaskStore:StorageBase<ShareNewTask>  {
        return try! store(id: "ShareNewTask") as! StorageBase<ShareNewTask>
    }
}
