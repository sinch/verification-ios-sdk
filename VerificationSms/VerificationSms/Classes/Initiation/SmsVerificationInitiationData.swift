//
//  SmsVerificationInitiationData.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore
import MetadataCollector

/// Class containing data that is passed with the sms verification initiation API call.
public struct SmsVerificationInitiationData: VerificationInitiationData, Encodable {
    
    public init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?, metadata: PhoneMetadata?) {
        self.identity = identity
        self.honourEarlyReject = honourEarlyReject
        self.custom = custom
        self.reference = reference
        self.metadata = metadata
    }
    
    public let method: VerificationMethodType = .sms
    
    public let identity: VerificationIdentity
    public let honourEarlyReject: Bool
    public let custom: String?
    public let reference: String?
    public let metadata: PhoneMetadata?
}
