//
//  NetworkInfoCollector.swift
//  Verification
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import UIKit
import Reachability

class NetworkInfoCollector: MetadataCollector {
    
    typealias CollectedType = NetworkInfo
    
    func collect() -> NetworkInfo {
        let reachability = try? Reachability()
        let type: NetworkType? = reachability?.connection.type
        
        return NetworkInfo(networkData: NetworkData(type: type))
    }
    
}

fileprivate extension Reachability.Connection {
    
    /// Maps Reachability connection type objects to ones used by SDK.
    var type: NetworkType {
        switch self {
        case .cellular:
            return .mobile
        case .wifi:
            return .wifi
        case .unavailable, .none:
            return .none
        }
    }
    
}
