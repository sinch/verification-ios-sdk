//
//  SeamlessVerificationInitiationData.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore
import MetadataCollector

/// Class containing data that is passed with the seamless verification initiation API call.
public struct SeamlessVerificationInitiationData: VerificationInitiationData, Encodable {
    
    public let method: VerificationMethodType = .seamless
    
    public let identity: VerificationIdentity
    public let honourEarlyReject: Bool
    public let custom: String?
    public let reference: String?
    public let metadata: PhoneMetadata?
    
    public init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?, metadata: PhoneMetadata?) {
        self.identity = identity
        self.honourEarlyReject = honourEarlyReject
        self.custom = custom
        self.reference = reference
        self.metadata = metadata
    }
    
}
