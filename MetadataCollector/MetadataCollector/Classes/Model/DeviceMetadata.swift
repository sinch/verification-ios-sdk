//
//  DeviceMetadata.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class holding general metadata of the device.
/// - TAG: DeviceMetadata
public struct DeviceMetadata: Encodable {
    
    /// Model of the device.
    public let model: String
}
