//
//  VerificationMethodType.swift
//  Verification
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Enum defining specific type of the verification.
/// - Tag: VerificationMethodType
public enum VerificationMethodType: String, Codable {
    
    /// SMS verification. [More](https://www.sinch.com/products/apis/verification/sms/)
    case sms
    
    /// FlashCall verification. [More](https://www.sinch.com/products/apis/verification/flash-call/)
    case flashcall
    
    /// Callout verification. [More](https://www.sinch.com/products/apis/verification/)
    case callout
    
    /// Seamless verification.
    case seamless
    
    /// Flag indicating if given method allows typing the verification code manually.
    var allowsManualVerification: Bool {
        return self != .seamless
    }
}
