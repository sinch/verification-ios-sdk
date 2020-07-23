//
//  IOSMetadataFactory.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

public class IOSMetadataFactory: PhoneMetadataFactory {
    
    private let osVersionCollector = OSMetadataCollector()
    private let deviceMetadataCollector = DeviceMetadataCollector()
    private let defaultLocaleCollector = DefaultLocaleCollector()
    private let batteryLevelCollector = BatteryLevelCollector()
    private let networkInfoCollector = NetworkInfoCollector()
    private let simInfoCollector = SimCardInfoCollector()
    private let configurationNameCollector = ConfiguarionNameCollector()
    
    public init() {}
    
    public func create() -> PhoneMetadata {
        return PhoneMetadata(
            os: osVersionCollector.collect(),
            deviceData: deviceMetadataCollector.collect(),
            simInfo: simInfoCollector.collect(),
            configuration: configurationNameCollector.collect(),
            defaultLocale: defaultLocaleCollector.collect(),
            networkInfo: networkInfoCollector.collect(),
            simCardsInfo: simInfoCollector.collect(),
            batteryLevel: batteryLevelCollector.collect()
        )
    }
    
}
