//
//  NetworkInfo.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class holding metadata describing current network the phone is connected to.
public struct NetworkInfo: Encodable {
    
    /// More detailed data about currently connected network.
    let networkData: NetworkData?
    
    enum CodingKeys: String, CodingKey {
        case networkData = "data"
    }
}
