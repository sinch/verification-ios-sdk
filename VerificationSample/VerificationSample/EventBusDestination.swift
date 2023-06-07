//
//  EventBusDestination.swift
//  VerificationSample
//
//  Created by Aleksander Wójcik on 07/06/2023.
//  Copyright © 2023 Aleksander Wojcik. All rights reserved.
//

import Foundation
import SwiftyBeaver
import SwiftEventBus

class EventBusDestination: BaseDestination {
    
    static let DEBUG_EVENT_NAME = "logMessageDebugEventName"
    static let INFO_EVENT_NAME = "logMessageInfoEventName"
    
    override func send(_ level: SwiftyBeaver.Level, msg: String, thread: String, file: String, function: String, line: Int, context: Any? = nil) -> String? {
        
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)
        switch level {
        case .debug:
            SwiftEventBus.post(EventBusDestination.DEBUG_EVENT_NAME, sender: formattedString)
        case .info:
            SwiftEventBus.post(EventBusDestination.INFO_EVENT_NAME, sender: formattedString)
        default: break
        }
        return formattedString
    }
}
