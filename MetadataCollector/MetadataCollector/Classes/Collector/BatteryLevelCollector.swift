//
//  BatteryLevelCollector.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import UIKit

/// Metadata collector responsible for collecting current battery level represented as percentage (String).
class BatteryLevelCollector: MetadataCollector {
    
    typealias CollectedType = String
    
    func collect() -> String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        let batteryLevelFormatted = "\(String(batteryLevel))%"
        UIDevice.current.isBatteryMonitoringEnabled = false
        return batteryLevelFormatted
    }
    
}
