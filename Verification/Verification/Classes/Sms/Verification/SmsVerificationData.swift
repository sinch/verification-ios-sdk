//
//  SmsVerificationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

struct SmsVerificationData: VerificationData, Encodable {
    
    let smsDetails: SmsVerificationDetails?
    let source: VerificationSourceType
    let method: VerificationMethodType = .sms
    
    enum CodingKeys: String, CodingKey {
        case source
        case method
        case smsDetails = "sms"
    }
}
