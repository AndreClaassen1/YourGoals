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
import YourGoalsKit

/// this class handles core data storage of several objects
class GoalsStorageManager:StorageManagerBase {
    
    static let modelName = "GoalsModel"
    static let defaultStorageManager = GoalsStorageManager(databaseName: "GoalsModel.sqlite")
    
    /// inititlaize the class for supporting basic core data operations
    ///
    /// - Parameter dataManager: datamanager class with access to core data storage
    init(dataManager: CoreDataManager) {
        super.init(dataManager: dataManager, stores:
            [
                StorageBase<Goal>(managedObjectContext: dataManager.managedObjectContext, entityName: "Goal"),
                StorageBase<ImageData>(managedObjectContext: dataManager.managedObjectContext, entityName: "ImageData"),
                StorageBase<Task>(managedObjectContext: dataManager.managedObjectContext, entityName: "Task"),
                StorageBase<TaskProgress>(managedObjectContext: dataManager.managedObjectContext, entityName: "TaskProgress"),
                StorageBase<Habit>(managedObjectContext: dataManager.managedObjectContext, entityName: "Habit"),
                StorageBase<HabitCheck>(managedObjectContext: dataManager.managedObjectContext, entityName: "HabitCheck")
            ])
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

    var habitStore:StorageBase<Habit> {
        return try! store(id: "Habit") as! StorageBase<Habit>
    }

    var habitCheckStore:StorageBase<HabitCheck> {
        return try! store(id: "HabitCheck") as! StorageBase<HabitCheck>
    }
    
   
    /// convinience initializer
    ///
    /// - Parameters:
    ///   - databaseName: database file name
    ///   - groupName: groupName, if the database lies in an application group
    ///   - journalingEnabled: true, if journaling is enabled (default)
    convenience init(databaseName: String, groupName: String? = nil, journalingEnabled: Bool = true) {
        self.init(dataManager: CoreDataManager(databaseName: databaseName, modelName: GoalsStorageManager.modelName, bundle: Bundle(for: GoalsStorageManager.self), groupName: groupName, journalingEnabled: journalingEnabled))
    }
}
