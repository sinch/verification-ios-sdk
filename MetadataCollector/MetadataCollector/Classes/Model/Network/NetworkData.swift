//
//  NetworkData.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class holding metadata about currently connected data network.
struct NetworkData: Encodable {
    
    /// Type of data network.
    let type: NetworkType?
    
}
