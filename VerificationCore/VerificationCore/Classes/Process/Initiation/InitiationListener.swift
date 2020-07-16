//
//  InitiationListener.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Interface defining methods notifying about verification initiation process result.
/// - TAG: InitiationListener
protocol InitiationListener {
    
    associatedtype T: InitiationResponseData
    
    /// Called when the initiation process has finished successfully.
    /// - Parameter data: Extra data that might be required during actual verification process.
    func onInitiated(_ data: InitiationResponseData)
    
    /// Called when the initiation process has failed.
    /// - Parameter e: Error data.
    func onInitiationFailed(e: Error)
    
}
