//
//  AutoVerificationEvent.swift
//  Verification
//
//  Created by Aleksander Wojcik on 17/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

/// VerificationEvent that can be created by the automatic verification method.
public enum AutoVerificationEvent: VerificationEvent {
    
    /// Event that is triggered whenever automatic verification tries to verify the number using given method.
    /// - method:  Method of the sub verification.
    case subMethodVerificationCallEvent(method: VerificationMethodType)
    
    /// Event that is triggered whenever automatic verification method fails the sub verification process.
    /// - method:  Method of the sub verification.
    /// - e: Error describing why sub verification has failed.
    case subMethodFailedEvent(method: VerificationMethodType, e: Error)
}
