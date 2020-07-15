//
//  VerificationIdentityType.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Enum representing different kind of identification methods user of the client app can use.
enum VerificationIdentityType: String, Encodable {
    
    /// Identification by the phone number.
    case number
}
