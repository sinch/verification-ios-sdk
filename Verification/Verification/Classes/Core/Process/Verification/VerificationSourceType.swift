//
//  VerificationSourceType.swift
//  Verification
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Enum representing different possible ways the verification code might be collected.
public enum VerificationSourceType: String, Codable {
    
    /// Code was automatically intercepted by the interceptor.
    case interception = "INTERCEPTION"
    
    /// Code was manually typed by the user.
    case manual = "MANUAL"
    
    /// Code was grabbed from the log. For example from the call history for flashcall verification method.
    case log = "LOG"
    
    /// Code was verified seamlessly.
    case seamless = "SEAMLESS"
}
