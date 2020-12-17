//
//  VerificationData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Common fields of verification data that is passed to the backend with the verification request.
protocol VerificationData: Encodable {
    
    /// Method of the verification.
    var method: VerificationMethodType { get }
    
    /// Source of the verification code.
    var source: VerificationSourceType { get }
    
    var smsDetails: SmsVerificationDetails? { get }
    
    var calloutDetails: CalloutVerificationDetails? { get }
    
    var flashcallDetails: FlashcallVerificationDetails? { get }
    
}

extension VerificationData {
    
    var smsDetails: SmsVerificationDetails? {
        return nil
    }
    
    var calloutDetails: CalloutVerificationDetails? {
        return nil
    }
    
    var flashcallDetails: FlashcallVerificationDetails? {
        return nil
    }
    
}
