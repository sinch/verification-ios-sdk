//
//  PhoneMetadata.swift
//  Verification
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Container class for all the metadata collected by the SDK.
struct PhoneMetadata: Encodable {
    
    /// Version of JSON that is sent to the API.
    let version: Int = 2
    
    /// User visibility version of the operating system (iOS).
    let os: String
    
    /// System the library is installed on (for Android SDK this value is always "iOS")
    let platform: String = "iOS"
    
    /// General device metadata.
    let deviceData: DeviceMetadata
    
    /// Metadata about installed sim card.
    let simInfo: SimCardsInfoHolder
    
    /// Configuration used to build the SDK
    let configuration: String
    
    /// Locale of the running application.
    let defaultLocale: String
    
    /// Metadata containing information about data network the phone is connected to.
    let networkInfo: NetworkInfo
    
    /// Container holding metadata about installed sim cards.
    let simCardsInfo: SimCardsInfoHolder
    
    /// Current battery level.
    let batteryLevel: String
    
    var simCardCount: Int? {
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
    
    func encode(to encoder: Encoder) throws {
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
