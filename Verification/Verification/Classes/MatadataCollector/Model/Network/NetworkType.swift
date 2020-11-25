//
//  NetworkType.swift
//  Verification
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Enum representing type of network (data connection) the phone might be connected to.
enum NetworkType: String, Encodable {
    
    /// Mobile provider data connection case.
    case mobile = "MOBILE"
    
    /// WiFi data connection case.
    case wifi = "WIFI"
    
    /// No data connection.
    
    case none = "Not Connected"
}
