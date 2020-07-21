//
//  VerificationIdentity.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class holding information about how user of the client app is identified.
public struct VerificationIdentity: Encodable {
    
    /// String identifying the user. Currently it is always user's phone number.
    public let endpoint: String
    
    /// Meaning of the endpoint property. Currently only VerificationIdentityType.number is used.
    let type: VerificationIdentityType = .number
    
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
    
}
