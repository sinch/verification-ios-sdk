//
//  VerificationMethodCallbacks.swift
//  Verification
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Protocol that needs to be conformed by each specific verification method, defining callbacks of the verification process.
protocol VerificationMethodCallbacks {
    
    /// Function called before specific verification methods initiate function is called.
    /// - Returns: True if the initiation process should begin, false otherwise.
    func onPreInitiate() -> Bool
    
    /// Reports the verification process result to Sinch backend.
    func report()
    
    /// Function called if the verification process is initiated. Verification method specific API calls should be implemented here.
    func onInitiate()
    
    /// Function called when code needs to be verified. Verification method specific API calls should be implemented here.
    /// - Parameters:
    ///   - verificationCode: Code to be verified.
    ///   - sourceType: Source of the verification code.
    func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType)
        
}
