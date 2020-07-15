//
//  Verification.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/**
 Interface collecting requirements each verification method must follow. After constructing specific verification instance it has to be successfully initiated. Then depending on verification method used the specific code needs to be passed back to backend.
 - Tag: Verification
 */
public protocol Verification {
    
    /// Current state of verification process.
    var verificationState: VerificationState { get }
    
    /// Initiates the verification process.
    func initiate()
    
    /// Verifies if provided code is correct.
    /// - Parameter verificationCode: Code to be verified.
    func verify(verificationCode: String)
    
    /// Stops the verification process. You can still verify the code manually for given verification.
    func stop()
}
