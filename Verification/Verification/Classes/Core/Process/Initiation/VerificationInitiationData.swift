//
//  VerificationInitiationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Common interface defining requirements of every initiation data different verification methods use.
protocol VerificationInitiationData {
    
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
    
    /// Phone Metadata collected for analytics purposes and self refejection rules
    var metadata: PhoneMetadata? { get }
    
    /// Initializer that creates verification initiation data based on method configuration.
    init(basedOnConfiguration config: VerificationMethodConfiguration)
    
    /// Initializer that creates verification initiation data based on arguments common to every verification method..
    init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?, metadata: PhoneMetadata?)
    
}

extension VerificationInitiationData {
    
    init(basedOnConfiguration config: VerificationMethodConfiguration) {
        self.init(identity: VerificationIdentity(endpoint: config.number ?? ""), honourEarlyReject: config.honoursEarlyReject, custom: config.custom, reference: config.reference, metadata: config.metadataFactory.create())
    }
    
}
