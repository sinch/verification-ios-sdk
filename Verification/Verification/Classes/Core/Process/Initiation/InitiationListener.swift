//
//  InitiationListener.swift
//  Verification
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

//TODO zrobić dodatkowo delegata w sms i flashcall method na SMSlistener itd


/// Interface defining methods notifying about verification initiation process result.
/// - TAG: InitiationListener
public protocol InitiationListener: AnyObject {
    
    /// Called when the initiation process has completed successfully.
    /// - Parameter data: Object containing detailed information about instantiated verification.
    func onInitiated(_ data: InitiationResponseData)
    
    /// Called when the initiation process has failed.
    /// - Parameter e: Error data.
    func onInitiationFailed(e: Error)
    
}

public extension InitiationListener {
    func onInitiated(_ data: InitiationResponseData) {}
    func onInitiationFailed(e: Error) {}
}
