//
//  AppBadgeActualizer.swift
//  YourGoals
//
//  Created by André Claaßen on 24.11.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//
import Foundation
import UIKit
import UserNotifications

/// this class actualizes the app badge icon with the number of tasks for the day
class AppBadgeActualizer : NSObject {
    
    fileprivate static var singleton:AppBadgeActualizer!
    
    let calculator:AppBadgeCalculator
    
    /// initialize the
    ///
    /// - Parameter storage: journal entry storage
    init(manager: GoalsStorageManager) {
        self.calculator = AppBadgeCalculator(manager: manager)
        super.init()
        
        self.actualize(forDate: Date(), withBackburned: SettingsUserDefault.standard.backburnedGoals)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNumberOfActionablesChanged(_:)), name: StrategyModelNotification.taskStateChanged.name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNumberOfActionablesChanged(_:)), name: StrategyModelNotification.habitCheckStateChanged.name, object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleNumberOfActionablesChanged(_:)), name: StrategyModelNotification.commitStateChanged.name, object: nil)
    }
    
    /// actualize the application badge with number of waiting actionables
    func actualize(forDate date: Date, withBackburned backburnedGoals:Bool) {
        do {
            let numberOfActiveActionables = try self.calculator.numberOfActiveActionables(forDate: date, withBackburned: backburnedGoals)
            let content = UNMutableNotificationContent()
            content.badge = numberOfActiveActionables
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "AppBadge", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: { error in
                if let error = error {
                    NSLog("actualize(forDate \(date)) failed with \(error)")
                }
            })
        }
        catch let error {
            NSLog("AppBadgeActualizer.actualize: couldn't calculate the number of actionables %@", error.localizedDescription)
        }
    }
    
    /// handler for the "journalEntriesChanged" notification
    ///
    /// - Parameter notification: number of pending and unsynchronized journal entries
    @objc func handleNumberOfActionablesChanged (_ notification: Notification) {
        actualize(forDate: Date(), withBackburned: SettingsUserDefault.standard.backburnedGoals)
    }
}

class AppBadgeActualizerInitializer:Initializer {
    func initialize(context:InitializerContext) {
        AppBadgeActualizer.singleton = AppBadgeActualizer(manager: context.defaultStorageManager)
    }
}



