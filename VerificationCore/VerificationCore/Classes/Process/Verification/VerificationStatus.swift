//
//  VerificationStatus.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Enum describing API status of the verification.
public enum VerificationStatus: String, Codable {
    
    /// Verification is ongoing.
    case pending = "PENDING"
    
    /// Verification has been successfully processed.
    case successful = "SUCCESSFUL"
    
    /// Verification attempt was made, but the number was not verified.
    case failed = "FAILED"
    
    /// Verification attempt was denied by Sinch or your backend.
    case denied = "DENIED"
    
    /// Verification attempt was aborted.
    case aborted = "ABORTED"
    
    /// Verification attempt could not be completed due to a network error or the number being unreachable.
    case error = "ERROR"
    
}
