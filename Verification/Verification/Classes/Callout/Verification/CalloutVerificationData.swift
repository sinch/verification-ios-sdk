//
//  CalloutVerificationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class containing data that is passed to the backend as the actual verification code check (phone number).
struct CalloutVerificationData: VerificationData, Encodable {

    /// Method of the verificaiton. Always .flashcall.
    let method: VerificationMethodType = .callout

    /// Details of the verification request containing actual code.
    let details: CalloutVerificationDetails
    
    /// Source of the verification. For now on iOS only manual verification is supported.
    let source: VerificationSourceType
        
    enum CodingKeys: String, CodingKey {
        case source
        case method
        case details = "callout"
    }
    
}

