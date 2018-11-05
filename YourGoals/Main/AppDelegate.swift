//
//  AppDelegate.swift
//  YourGoals
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit
import UserNotifications
import YourGoalsKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var watchConnectivityHandler:WatchConnectivityHandlerForApp!
    var taskNotificationScheduler:TaskNotificationScheduler!
    var taskNotificationHandler:TaskNotificationHandler!
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initAll()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        consumeTasksFromShareExtension()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: my own logic
    
    /// consume the tasks from the data store of the share extensions
    func consumeTasksFromShareExtension() {
        let shareTasksConsumer = ShareTasksConsumer(
            goalsStorageManager: GoalsStorageManager.defaultStorageManager,
            shareStorageManager: ShareStorageManager.defaultStorageManager)
        
        shareTasksConsumer.consumeTasksFromShare(forDate: Date())
    }
    
    func initAll() {
        let context = InitializerContext(defaultStorageManager: GoalsStorageManager.defaultStorageManager)
        
        let initializers:[Initializer] = [
            TestDataInitializer(),
            AppBadgeActualizerInitializer()
        ]

        for initializer in initializers {
            initializer.initialize(context: context)
        }
        
        self.watchConnectivityHandler = WatchConnectivityHandlerForApp(observer: TaskNotificationObserver.defaultObserver, manager: GoalsStorageManager.defaultStorageManager)
        self.taskNotificationScheduler = TaskNotificationScheduler(notificationCenter: UNUserNotificationCenter.current(), observer: TaskNotificationObserver.defaultObserver)
        self.taskNotificationHandler = TaskNotificationHandler(manager: GoalsStorageManager.defaultStorageManager)
        self.taskNotificationHandler.registerNotifications()
        consumeTasksFromShareExtension()
    }
}

