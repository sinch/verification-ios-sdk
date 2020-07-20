//
//  SmsVerificationData.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore

public struct SmsVerificationData: VerificationData, Encodable {
    
    let details: SmsVerificationDetails
    public let source: VerificationSourceType
    public let method: VerificationMethodType = .sms
    
    enum CodingKeys: String, CodingKey {
        case source
        case method
        case details = "sms"
    }
}
