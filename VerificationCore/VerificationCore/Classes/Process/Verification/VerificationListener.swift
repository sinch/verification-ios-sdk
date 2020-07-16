//
//  VerificationListener.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Listener holding callbacks invoked by the [Verification](x-source-tag://[Verification]) implementations notifying about the verification process result.
/// - TAG: VerificationListener
protocol VerificationListener {
    
    /// Called after entire verification process has finished successfully.
    func onVerified()
    
    /// Called when the verification process has finished with an error.
    /// - Parameter e: Error describing the reason why the process has failed.
    func onVerificationFailed(e: Error)
    
}
