//
//  SmsVerificationInitiationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing data that is passed with the sms verification initiation API call.
struct SmsVerificationInitiationData: VerificationInitiationData, Encodable {
    
    init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?, metadata: PhoneMetadata?) {
        self.identity = identity
        self.honourEarlyReject = honourEarlyReject
        self.custom = custom
        self.reference = reference
        self.metadata = metadata
    }
    
    let method: VerificationMethodType = .sms
    
    let identity: VerificationIdentity
    let honourEarlyReject: Bool
    let custom: String?
    let reference: String?
    let metadata: PhoneMetadata?
}
