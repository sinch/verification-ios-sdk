//
//  VerificationState.swift
//  Verification
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Current state of the verification process.
/// - Tag: VerificationState
public enum VerificationState: Equatable {
    
    /// Verification instance has been constructed but it was manually stopped.
    case idle
    
    /// Verification instance has been constructed but it was manually stopped.
    case manuallyStopped
    
    /// The process of initialization has started.
    /// - status:   Current status of initialization.
    case initialization(status: VerificationStateStatus)
    
    /// The process of verification has started. This state is set once the [Verification] verify method is called.
    /// - status:   Current status of verification.
    case verification(status: VerificationStateStatus)
    
    /// Flag indicating if the verification process has finished successfully.
    var isVerified: Bool {
        return self == VerificationState.verification(status: .success)
    }
    
    /// Flag indicating if the the verification process can be initiated.
    var canInitiate: Bool {
        switch self {
        case .idle:
            return true
        case .initialization(let status):
            return status.isFinished
        default:
            return false
        }
    }
    
    /// Flag indicating if new verification code can be verified.
    var canVerify: Bool {
        switch self {
        case .verification(let status):
            return status == .error
        default:
            return true
        }
    }
    
    /// Flag indicating if the verification process has been completed (either with error or success).
    var isVerificationProcessFinished: Bool {
        switch self {
        case .verification(let status):
            return status.isFinished
        case .initialization(let status):
            return status == .error
        case .manuallyStopped:
            return true
        default:
            return false
        }
    }
    
}
