//
//  VerificationData.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Common fields of verification data that is passed to the backend with the verification request.
public protocol VerificationData {
    
    /// Method of the verification.
    var method: VerificationMethodType { get }
    
    /// Source of the verification code.
    var source: VerificationSourceType { get }
}
