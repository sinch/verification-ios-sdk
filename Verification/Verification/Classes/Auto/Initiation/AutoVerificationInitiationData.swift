//
//  AutoVerificationInitiationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

/// Class containing data that is passed with the auto verification initiation API call.
struct AutoVerificationInitiationData: VerificationInitiationData, Encodable {
    
    init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?, metadata: PhoneMetadata?) {
        self.identity = identity
        self.honourEarlyReject = honourEarlyReject
        self.custom = custom
        self.reference = reference
        self.metadata = metadata
    }
    
    let method: VerificationMethodType = .auto
    
    let identity: VerificationIdentity
    let honourEarlyReject: Bool
    let custom: String?
    let reference: String?
    let metadata: PhoneMetadata?
}
