//
//  OSMetadataCollector.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//
import UIKit

class OSMetadataCollector: MetadataCollector {
    
    typealias CollectedType = String
    
    func collect() -> String {
        return UIDevice.current.systemVersion
    }
    
}
