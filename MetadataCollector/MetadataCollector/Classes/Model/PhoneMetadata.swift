//
//  PhoneMetadata.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Container class for all the metadata collected by the SDK.
public struct PhoneMetadata: Encodable {
    
    /// Version of JSON that is sent to the API.
    public let version: Int = 2
    
    /// User visibility version of the operating system (iOS).
    public let os: String
    
    /// System the library is installed on (for Android SDK this value is always "iOS")
    public let platform: String = "iOS"
    
    /// General device metadata.
    public let deviceData: DeviceMetadata
    
    /// Metadata about installed sim card.
    public let simInfo: SimCardsInfoHolder
    
    /// Configuration used to build the SDK
    public let configuration: String
    
    /// Locale of the running application.
    public let defaultLocale: String
    
    /// Metadata containing information about data network the phone is connected to.
    public let networkInfo: NetworkInfo
    
    /// Container holding metadata about installed sim cards.
    public let simCardsInfo: SimCardsInfoHolder
    
    /// Current battery level.
    public let batteryLevel: String
    
    public var simCardCount: Int? {
        return simCardsInfo.simCardsCount
    }
            
    enum CodingKeys: String, CodingKey {
        case version
        case os
        case platform
        case deviceData = "device"
        case configuration = "buildFlavor" //Sinch api uses Android naming here
        case defaultLocale
        case networkInfo
        case batteryLevel
        case simCardsInfo
        case simCardCount
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(os, forKey: .os)
        try container.encode(platform, forKey: .platform)
        try container.encode(deviceData, forKey: .deviceData)
        try container.encode(configuration, forKey: .configuration)
        try container.encode(defaultLocale, forKey: .defaultLocale)
        try container.encode(networkInfo, forKey: .networkInfo)
        try container.encode(batteryLevel, forKey: .batteryLevel)
        try container.encode(simCardsInfo, forKey: .simCardsInfo)
        try container.encode(simCardCount, forKey: .simCardCount)
    }
    
}
