//
//  SmsVerificationDetails.swift
//  Verification
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing detailed information for the actual verification API request.
struct SmsVerificationDetails: Codable {
        
    /// Verification code received in the SMS message.
    let code: String
}
