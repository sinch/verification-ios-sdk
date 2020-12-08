//
//  FlashcallVerificationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 29/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class containing data that is passed to the backend as the actual verification code check (phone number).
struct FlashcallVerificationData: VerificationData, Encodable {
    
    /// Method of the verificaiton. Always .flashcall.
    let method: VerificationMethodType = .flashcall

    /// Details of the verification request containing actual code - in case of flashcall incoming phone number.
    let flashcallDetails: FlashcallVerificationDetails?
    
    /// Source of the verification. For now on iOS only manual verification is supported.
    let source: VerificationSourceType
        
    enum CodingKeys: String, CodingKey {
        case source
        case method
        case flashcallDetails = "flashcall"
    }
    
}
