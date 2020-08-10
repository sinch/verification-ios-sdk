//
//  SeamlessVerificationInitiationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class containing data that is passed with the seamless verification initiation API call.
struct SeamlessVerificationInitiationData: VerificationInitiationData, Encodable {
    
    let method: VerificationMethodType = .seamless
    
    let identity: VerificationIdentity
    let honourEarlyReject: Bool
    let custom: String?
    let reference: String?
    let metadata: PhoneMetadata?
    
    init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?, metadata: PhoneMetadata?) {
        self.identity = identity
        self.honourEarlyReject = honourEarlyReject
        self.custom = custom
        self.reference = reference
        self.metadata = metadata
    }
    
}
