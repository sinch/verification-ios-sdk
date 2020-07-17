//
//  InitiationListener.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Interface defining methods notifying about verification initiation process result.
/// - TAG: InitiationListener
public protocol InitiationListener: class {
    
    /// Called when the initiation process has failed.
    /// - Parameter e: Error data.
    func onInitiationFailed(e: Error)
    
}
