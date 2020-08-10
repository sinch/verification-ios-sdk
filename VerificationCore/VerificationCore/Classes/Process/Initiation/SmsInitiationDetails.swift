//
//  SmsInitiationDetails.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 07/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing details (returned by the API) about the initiated sms verification process.
public struct SmsInitiationDetails: Decodable {
    let template: String
}
