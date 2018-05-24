//
//  WatchActionSender.swift
//  YourGoals WatchKit Extension
//
//  Created by André Claaßen on 24.05.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class WatchActionSender {
    let session:WCSession
    
    init(session:WCSession) {
        self.session = session
    }

    func send(action: WatchAction, taskUri uri:String? = nil, taskDescription description:String? = nil) {
        var userInfo = [String:Any]()
        
        userInfo["action"] = action.rawValue
        if uri != nil {
            userInfo["taskUri"] = uri
        }
        
        if description != nil {
            userInfo["description"] = description
        }
        
        session.sendMessage(userInfo, replyHandler: nil, errorHandler: nil)
    }
}
