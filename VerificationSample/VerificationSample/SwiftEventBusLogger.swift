//
//  SwiftEventBusLogger.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 14/12/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation
import CocoaLumberjack
import SwiftEventBus

class SwiftEventBusLogger: DDAbstractLogger {
    
    static var sharedInstance: SwiftEventBusLogger =
        SwiftEventBusLogger()
    
    private override init() {}
    
    static let DEBUG_EVENT_NAME = "logMessageDebugEventName"
    static let INFO_EVENT_NAME = "logMessageInfoEventName"

    override func log(message logMessage: DDLogMessage) {
        print("Log level is \(logMessage.flag) \(logMessage.level)")
        switch logMessage.flag {
        case .debug:
            SwiftEventBus.post(SwiftEventBusLogger.DEBUG_EVENT_NAME, sender: logMessage)
        case .info:
            SwiftEventBus.post(SwiftEventBusLogger.INFO_EVENT_NAME, sender: logMessage)
        default: break
        }
    }
    
}
