//
//  DeviceMetadata.swift
//  Verification
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class holding general metadata of the device.
/// - TAG: DeviceMetadata
struct DeviceMetadata: Encodable {
    
    /// Model of the device.
    let model: String
}
