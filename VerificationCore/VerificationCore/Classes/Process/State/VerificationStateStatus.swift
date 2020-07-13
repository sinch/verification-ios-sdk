//
//  VerificationStateStatus.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Enum defining different statuses of [VerificationState](x-source-tag://[VerificationState])
enum VerificationStateStatus {
    
    /// State is "active" meaning that probably an API call is being made and the result is not known yet.
    case ongoing
    
    /// The step has been successfully processed.
    case success
    
    /// The step has not been successfully processed.
    case error
    
    /// Flag indicating if state result has been resolved.
    var isFinished: Bool {
        self != VerificationStateStatus.ongoing
    }
    
}
