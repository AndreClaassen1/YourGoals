//
//  TestDataGenerator.swift
//  YourFitnessPlan
//
//  Created by André Claaßen on 21.05.16.
//  Copyright © 2016 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

class TestDataGenerator {

    let manager:GoalsStorageManager!
    let generators:[GeneratorProtocol]
    
    init(manager:GoalsStorageManager) {
        self.manager = manager
        
        generators = [
            StrategyGenerator(manager: self.manager),
         ]
    }
    
//    func createFitnessPlan() throws  {
//        let planData = [
//                        (fitnessNr: 1, settingSeat: 5, settingFoot: 2, fitnessDevice: "Laufband Start",         movements: "1x", repeatments: "10 min", weight: 11.0),
//                        (fitnessNr: 2, settingSeat: 0, settingFoot: 0, fitnessDevice: "A01 Brustpresse",        movements: "3x", repeatments: "10-12",  weight: 33.0),
//                        (fitnessNr: 3, settingSeat: 0, settingFoot: 0, fitnessDevice: "A02 Butterfly",          movements: "3x", repeatments: "10-12",  weight: 25.0),
//                        (fitnessNr: 4, settingSeat: 9, settingFoot: 0, fitnessDevice: "B02 Latzugmaschine",     movements: "3x", repeatments: "10-12",  weight: 15.0),
//                        (fitnessNr: 5, settingSeat: 4, settingFoot: 0, fitnessDevice: "B01 Ruderzugmaschine",   movements: "3x", repeatments: "10-12",  weight: 25.0),
//                        (fitnessNr: 6, settingSeat: 6, settingFoot: 0, fitnessDevice: "E01 Beinpresse",         movements: "3x", repeatments: "10-12",  weight: 30.5),
//                        (fitnessNr: 7, settingSeat: 0, settingFoot: 0, fitnessDevice: "F01 Crunch",             movements: "3x", repeatments: "10-12",  weight: 15.0),
//                        (fitnessNr: 8, settingSeat: 7, settingFoot: 0, fitnessDevice: "B03 Rückenstrecker",     movements: "3x", repeatments: "10-12",  weight: 15.0),
//                        (fitnessNr: 9, settingSeat: 5, settingFoot: 2, fitnessDevice: "Laufband Ende",          movements: "1x", repeatments: "15 min", weight: 15.0),
//
//// Old Fitness Plan from Lünen
//            (fitnessNr: 1, settingSeat: 5, settingFoot: 2, fitnessDevice: "Leg Press",         movements: "2-3x", repeatments: "10-12", weight: 55.0),
//            (fitnessNr: 2, settingSeat: 0, settingFoot: 0, fitnessDevice: "Lattenzug - Vorn",  movements: "2-3x", repeatments: "10-12", weight: 33.0),
//            (fitnessNr: 3, settingSeat: 0, settingFoot: 0, fitnessDevice: "Rudern Kabelzug",   movements: "2-3x", repeatments: "10-12", weight: 26.0),
//            (fitnessNr: 4, settingSeat: 9, settingFoot: 0, fitnessDevice: "Shoulder Press",    movements: "2-3x", repeatments: "10-12", weight: 15.0),
//            (fitnessNr: 5, settingSeat: 4, settingFoot: 0, fitnessDevice: "Pectoral Machine",  movements: "2-3x", repeatments: "10-12", weight: 30.0),
//            (fitnessNr: 6, settingSeat: 6, settingFoot: 0, fitnessDevice: "Chess Incline",     movements: "2-3x", repeatments: "10-12", weight: 27.5),
//            (fitnessNr: 7, settingSeat: 0, settingFoot: 0, fitnessDevice: "Total Abdominal",   movements: "2-3x", repeatments: "10-12", weight: 35.0),
//            (fitnessNr: 8, settingSeat: 7, settingFoot: 0, fitnessDevice: "Lower Back",        movements: "2-3x", repeatments: "10-12", weight: 20.0)
//        ]
        
//        let fitnessPlan = manager.fitnessPlanStore.createPersistentObject()
//        fitnessPlan.coach = "Karsten"
//        fitnessPlan.name = "Ziel - Basistraining"
//        fitnessPlan.creationDate = self.planDate
//        fitnessPlan.endDate = self.historyEndDate
//
//        for tuple in planData {
//            let fitnessPlanItem = manager.fitnessPlanItemStore.createPersistentObject()
//            fitnessPlanItem.planPosition = NSNumber(value: tuple.fitnessNr)
//            fitnessPlanItem.device = try manager.fitnessDevice(name: tuple.fitnessDevice)
//            fitnessPlanItem.actualWeight = NSNumber(value: tuple.weight)
//            fitnessPlanItem.startWeight = NSNumber(value: tuple.weight)
//            fitnessPlanItem.settingFoot = NSNumber(value: tuple.settingFoot)
//            fitnessPlanItem.settingSeat  = NSNumber(value: tuple.settingSeat)
//            fitnessPlanItem.repeatments = tuple.repeatments
//            fitnessPlanItem.movements  = tuple.movements
//            fitnessPlanItem.plan = fitnessPlan
//            fitnessPlanItem.guid = UUID().uuidString
//        }
//
//        try manager.dataManager.saveContext()
  //  }
    
    func createTestStrategy() throws {
        try manager.deleteRepository()
        try generators.forEach{ try $0.generate() }
        try manager.dataManager.saveContext()
    }
}
