//
//  SmsInitiationResponseData.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore

/// Class containing data returned by the API in response to sms verification initiation request.
public struct SmsInitiationResponseData: InitiationResponseData, Decodable {
    
    /// Id of the verification.
    public let id: String
    
    /// Method of the verification. Always .sms
    public let method: VerificationMethodType = .sms
    
    /// Details of the initiated sms verification process.
    public let details: SmsInitiationDetails
}
