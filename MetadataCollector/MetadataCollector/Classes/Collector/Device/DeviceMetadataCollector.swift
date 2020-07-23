//
//  DeviceMetadataCollector.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import UIKit

/// Metadata collector responsible for collecting metadata of type [DeviceMetadata](x-source-tag://[DeviceMetadata])
class DeviceMetadataCollector: MetadataCollector {
    
    typealias CollectedType = DeviceMetadata
    
    func collect() -> DeviceMetadata {
        return DeviceMetadata(model: UIDevice().type.rawValue)
    }
    
}
