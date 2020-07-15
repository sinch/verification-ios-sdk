//
//  VerificationInitiationData.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Common interface defining requirements of every initiation data different verification methods use.
public protocol VerificationInitiationData {
    
    /// Method of the verification.
    var method: VerificationMethodType { get }
    
    /// Identity of the verification.
    var identity: VerificationIdentity { get }
    
    /// Flag indicating if verification process should use early rejection rules.
    var honourEarlyReject: Bool { get }
    
    /// Custom string passed in the initiation API call.
    var custom: String? { get }
    
    /// Custom string that can be passed in the request for tracking purposes.
    var reference: String? { get }
    
}
