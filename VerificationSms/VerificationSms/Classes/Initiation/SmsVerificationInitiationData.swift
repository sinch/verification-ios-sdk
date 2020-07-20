//
//  SmsVerificationInitiationData.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore

/// Class containing data that is passed with the sms verification initiation API call.
public struct SmsVerificationInitiationData: VerificationInitiationData, Encodable {
    
    init(basedOnConfiguartion config: VerificationMethodConfiguration) {
        self.init(
            identity: VerificationIdentity(endpoint: config.number),
            honourEarlyReject: config.honoursEarlyReject,
            custom: config.custom,
            reference: config.reference
        )
    }
    
    init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?) {
        self.identity = identity
        self.honourEarlyReject = honourEarlyReject
        self.custom = custom
        self.reference = reference
    }
    
    public let method: VerificationMethodType = .sms
    
    public let identity: VerificationIdentity
    public let honourEarlyReject: Bool
    public let custom: String?
    public let reference: String?
}
