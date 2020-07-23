//
//  MetadataCollector.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Base interface for collecting phone metadata used by Sinch API mostly for analytics and early rejection rules.
protocol MetadataCollector {
    associatedtype CollectedType
    
    func collect() -> CollectedType
}
